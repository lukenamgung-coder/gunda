package com.gunda.app

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import android.app.usage.UsageStatsManager
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import org.json.JSONObject
import java.io.File
import java.util.Calendar

/**
 * Foreground service that runs nightly verification for all active vows.
 *
 * Flow:
 *   1. startForeground → "서약 검증 중" notification
 *   2. Open gunda.sqlite (raw SQLite — Drift not available in background)
 *   3. Query active vows
 *   4. Verify each vow by pledge type
 *   5. INSERT verifications row (isPassed 0/1)
 *   6. On failure: INSERT violations row + UPDATE vow status → 'violated'
 *   7. Post violation notification per failed vow
 *   8. Reschedule alarm for next midnight
 *   9. stopSelf()
 *
 * DB datetime storage: Drift NativeDatabase stores DateTime as ISO-8601 TEXT.
 * All date comparisons use string prefix matching ("YYYY-MM-DD").
 */
class PledgeMonitorService : Service() {

    private val job = SupervisorJob()
    private val scope = CoroutineScope(Dispatchers.IO + job)

    // ── Lifecycle ────────────────────────────────────────────

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        ensureNotificationChannels()
        startForeground(NOTIF_PROGRESS_ID, buildProgressNotification())

        scope.launch {
            try {
                runVerification()
            } catch (e: Exception) {
                Log.e(TAG, "Verification failed", e)
            } finally {
                scheduleNextMidnight(applicationContext)
                stopSelf(startId)
            }
        }

        return START_NOT_STICKY
    }

    override fun onDestroy() {
        job.cancel()
        super.onDestroy()
    }

    // ── Core verification loop ────────────────────────────────

    private fun runVerification() {
        val dbFile = File(applicationContext.filesDir, "gunda.sqlite")
        if (!dbFile.exists()) {
            Log.w(TAG, "DB not found — skipping verification")
            return
        }

        SQLiteDatabase.openDatabase(
            dbFile.absolutePath,
            null,
            SQLiteDatabase.OPEN_READWRITE,
        ).use { db ->
            completeExpiredVows(db)
            val activeVows = queryActiveVows(db)
            val nickname = queryUserNickname(db)
            Log.i(TAG, "Verifying ${activeVows.size} active vow(s) for $nickname")

            for (vow in activeVows) {
                verifyVow(vow, db, nickname)
            }
        }
    }

    // ── DB queries ────────────────────────────────────────────

    private data class VowRow(
        val id: Long,
        val title: String,
        val pledgeType: String,
        val conditionJson: String,
        val penaltyAmount: Long,
    )

    private fun queryUserNickname(db: SQLiteDatabase): String {
        db.rawQuery("SELECT nickname FROM users LIMIT 1", null).use { c ->
            return if (c.moveToFirst()) c.getString(0) else "사용자"
        }
    }

    private fun queryActiveVows(db: SQLiteDatabase): List<VowRow> {
        val result = mutableListOf<VowRow>()
        db.rawQuery(
            "SELECT id, title, pledge_type, condition_json, penalty_amount " +
                "FROM vows WHERE status = 'active'",
            null,
        ).use { c ->
            while (c.moveToNext()) {
                result += VowRow(
                    id = c.getLong(0),
                    title = c.getString(1),
                    pledgeType = c.getString(2),
                    conditionJson = c.getString(3),
                    penaltyAmount = c.getLong(4),
                )
            }
        }
        return result
    }

    /** Mark any active vows whose end_date has passed as completed. */
    private fun completeExpiredVows(db: SQLiteDatabase) {
        val today = todayDatePrefix()
        db.execSQL(
            "UPDATE vows SET status = 'completed', updated_at = ? " +
                "WHERE status = 'active' AND end_date < ?",
            arrayOf(isoNow(), today),
        )
    }

    private fun todayAlreadyVerified(db: SQLiteDatabase, vowId: Long): Boolean {
        val todayPrefix = todayDatePrefix()
        db.rawQuery(
            "SELECT COUNT(*) FROM verifications " +
                "WHERE vow_id = ? AND target_date LIKE ?",
            arrayOf(vowId.toString(), "$todayPrefix%"),
        ).use { c ->
            return c.moveToFirst() && c.getLong(0) > 0
        }
    }

    // ── Per-vow verification ──────────────────────────────────

    private fun verifyVow(vow: VowRow, db: SQLiteDatabase, nickname: String) {
        if (todayAlreadyVerified(db, vow.id)) {
            Log.d(TAG, "Vow #${vow.id} already verified today — skipping")
            return
        }

        val condition = runCatching { JSONObject(vow.conditionJson) }.getOrNull()
            ?: return

        var measuredMinutes: Long? = null
        val passed = when (vow.pledgeType) {
            "screenTime", "game" -> {
                val (result, minutes) = verifyUsageBased(condition, vow.pledgeType)
                measuredMinutes = minutes
                result
            }
            "delivery" -> {
                val (result, minutes) = verifyDelivery(condition)
                measuredMinutes = minutes
                result
            }
            "custom" -> false // custom vows require manual check; auto-fail at midnight
            // steps / sleep / exercise: no background data source available yet
            else -> true
        }

        val measuredJson = buildMeasuredJson(vow.pledgeType, condition, measuredMinutes)
        val verificationId = insertVerification(
            db = db,
            vowId = vow.id,
            isPassed = passed,
            measuredDataJson = measuredJson,
        )

        if (!passed) {
            insertViolation(db, vow.id, verificationId, vow.penaltyAmount)
            updateVowStatus(db, vow.id, "violated")
            postViolationNotification(
                notifId = (2000 + vow.id).toInt(),
                vowTitle = vow.title,
                penaltyAmount = vow.penaltyAmount,
                vowId = vow.id,
                nickname = nickname,
            )
        }
    }

    // ── Type-specific checks ──────────────────────────────────

    private fun verifyUsageBased(condition: JSONObject, type: String): Pair<Boolean, Long> {
        val hasDurationLimit = condition.optBoolean("hasDurationLimit", true)
        if (!hasDurationLimit) return Pair(checkWindowOnly(condition), 0L)

        val targetValue = condition.optDouble("targetValue", 0.0)
        val limitMinutes = (targetValue * 60).toLong()

        val packageNames: List<String> = condition.optJSONArray("targetApps")
            ?.let { arr -> (0 until arr.length()).map { arr.getString(it) } }
            ?: emptyList()

        val usedMinutes = if (packageNames.isEmpty()) {
            getTotalUsageTodayMinutes()
        } else {
            packageNames.sumOf { getAppUsageTodayMinutes(it) }
        }

        return Pair(usedMinutes <= limitMinutes, usedMinutes)
    }

    private fun verifyDelivery(condition: JSONObject): Pair<Boolean, Long> {
        // Fixed delivery app packages
        val deliveryApps = listOf(
            "com.etc.baemin",        // 배달의민족
            "com.coupang.deliverapp", // 쿠팡이츠
            "kr.co.yogiyo.app",      // 요기요
        )
        val totalUsed = deliveryApps.sumOf { getAppUsageTodayMinutes(it) }
        // Any usage of a delivery app today = violation
        return Pair(totalUsed == 0L, totalUsed)
    }

    private fun checkWindowOnly(condition: JSONObject): Boolean {
        val windowStart = condition.optInt("windowStartHour", -1)
        val windowEnd = condition.optInt("windowEndHour", -1)
        if (windowStart < 0 || windowEnd < 0) return true

        val hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
        // Violation if used during the forbidden window — we can't check this
        // retroactively without usage events; pass for now
        return true
    }

    // ── UsageStats helpers ────────────────────────────────────

    private fun getAppUsageTodayMinutes(packageName: String): Long {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager ?: return 0L
        val now = System.currentTimeMillis()
        val startOfDay = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val stats = usm.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, startOfDay, now,
        )
        val ms = stats?.find { it.packageName == packageName }
            ?.totalTimeInForeground ?: 0L
        return ms / 60_000L
    }

    private fun getTotalUsageTodayMinutes(): Long {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager ?: return 0L
        val now = System.currentTimeMillis()
        val startOfDay = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val stats = usm.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, startOfDay, now,
        )
        return (stats?.sumOf { it.totalTimeInForeground } ?: 0L) / 60_000L
    }

    // ── DB writes ─────────────────────────────────────────────

    private fun insertVerification(
        db: SQLiteDatabase,
        vowId: Long,
        isPassed: Boolean,
        measuredDataJson: String?,
    ): Long {
        val now = isoNow()
        return db.execSQL(
            "INSERT INTO verifications (vow_id, target_date, verified_at, is_passed, measured_data_json, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?)",
            arrayOf(vowId, now, now, if (isPassed) 1 else 0, measuredDataJson, now),
        ).let {
            // Return last inserted row id
            db.rawQuery("SELECT last_insert_rowid()", null).use { c ->
                if (c.moveToFirst()) c.getLong(0) else -1L
            }
        }
    }

    private fun insertViolation(
        db: SQLiteDatabase,
        vowId: Long,
        verificationId: Long,
        penaltyAmount: Long,
    ) {
        val now = isoNow()
        db.execSQL(
            "INSERT INTO violations (vow_id, verification_id, violated_at, penalty_amount, payment_status, created_at) " +
                "VALUES (?, ?, ?, ?, 'pending', ?)",
            arrayOf(vowId, verificationId, now, penaltyAmount, now),
        )
    }

    private fun updateVowStatus(db: SQLiteDatabase, vowId: Long, status: String) {
        db.execSQL(
            "UPDATE vows SET status = ?, updated_at = ? WHERE id = ?",
            arrayOf(status, isoNow(), vowId),
        )
    }

    // ── Notifications ─────────────────────────────────────────

    private fun ensureNotificationChannels() {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        listOf(
            NotificationChannel(
                CH_PROGRESS, "서약 검증",
                NotificationManager.IMPORTANCE_LOW,
            ),
            NotificationChannel(
                CH_VIOLATION, "서약 위반",
                NotificationManager.IMPORTANCE_HIGH,
            ).apply { description = "서약 위반 감지 및 납부 안내" },
        ).forEach { nm.createNotificationChannel(it) }
    }

    private fun buildProgressNotification() =
        NotificationCompat.Builder(this, CH_PROGRESS)
            .setSmallIcon(android.R.drawable.ic_menu_recent_history)
            .setContentTitle("건다")
            .setContentText("서약 검증 중...")
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()

    private fun postViolationNotification(
        notifId: Int,
        vowTitle: String,
        penaltyAmount: Long,
        vowId: Long,
        nickname: String = "사용자",
    ) {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val body = "${nickname}이(가) 서약을 어겼습니다 — ${formatAmount(penaltyAmount)} 송금 대상"

        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            ?.apply { putExtra("vowId", vowId) }
        val pi = PendingIntent.getActivity(
            this, notifId.toInt(), launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val notif = NotificationCompat.Builder(this, CH_VIOLATION)
            .setSmallIcon(android.R.drawable.ic_dialog_alert)
            .setContentTitle("$vowTitle — 계약 위반")
            .setContentText(body)
            .setContentIntent(pi)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()

        nm.notify(notifId, notif)
    }

    // ── Utilities ─────────────────────────────────────────────

    private fun todayDatePrefix(): String {
        val c = Calendar.getInstance()
        return "%04d-%02d-%02d".format(
            c.get(Calendar.YEAR),
            c.get(Calendar.MONTH) + 1,
            c.get(Calendar.DAY_OF_MONTH),
        )
    }

    private fun isoNow(): String {
        val c = Calendar.getInstance()
        return "%04d-%02d-%02dT%02d:%02d:%02d.000".format(
            c.get(Calendar.YEAR),
            c.get(Calendar.MONTH) + 1,
            c.get(Calendar.DAY_OF_MONTH),
            c.get(Calendar.HOUR_OF_DAY),
            c.get(Calendar.MINUTE),
            c.get(Calendar.SECOND),
        )
    }

    private fun buildMeasuredJson(
        pledgeType: String,
        condition: JSONObject,
        measuredMinutes: Long? = null,
    ): String {
        return JSONObject().apply {
            put("type", pledgeType)
            put("checkedAt", isoNow())
            if (measuredMinutes != null) {
                put("measuredMinutes", measuredMinutes)
            }
        }.toString()
    }

    private fun formatAmount(amount: Long): String {
        val s = amount.toString()
        val sb = StringBuilder()
        s.forEachIndexed { i, c ->
            if (i > 0 && (s.length - i) % 3 == 0) sb.append(',')
            sb.append(c)
        }
        return "${sb}원"
    }

    // ── Static helpers ────────────────────────────────────────

    companion object {
        private const val TAG = "PledgeMonitor"
        private const val NOTIF_PROGRESS_ID = 1001
        private const val CH_PROGRESS = "pledge_progress"
        private const val CH_VIOLATION = "violations"
        private const val ALARM_REQUEST_CODE = 9001

        /**
         * Schedules [VerificationAlarmReceiver] to fire at the next midnight.
         * Safe to call multiple times — replaces any existing alarm.
         */
        fun scheduleNextMidnight(context: Context) {
            val midnight = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }.timeInMillis

            val intent = Intent(context, VerificationAlarmReceiver::class.java)
            val pi = PendingIntent.getBroadcast(
                context,
                ALARM_REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )

            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            // setExact is sufficient; we don't need per-second accuracy
            am.setExact(AlarmManager.RTC_WAKEUP, midnight, pi)

            Log.i(TAG, "Alarm scheduled for next midnight (${midnight})")
        }
    }
}
