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
import android.app.usage.UsageEvents
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

        val vowId = intent?.getLongExtra("vowId", -1L) ?: -1L

        scope.launch {
            try {
                if (vowId > 0L) {
                    runVerificationForVow(vowId)
                } else {
                    // Fallback: verify all active vows (boot recovery / manual trigger)
                    runVerification()
                }
            } catch (e: Exception) {
                Log.e(TAG, "Verification failed", e)
            } finally {
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

    /** Verify a single vow by ID. Used by per-vow alarms. */
    private fun runVerificationForVow(vowId: Long) {
        val dbFile = File(applicationContext.filesDir, "gunda.sqlite")
        if (!dbFile.exists()) {
            Log.w(TAG, "DB not found — skipping verification for vow #$vowId")
            return
        }
        SQLiteDatabase.openDatabase(
            dbFile.absolutePath, null, SQLiteDatabase.OPEN_READWRITE,
        ).use { db ->
            completeExpiredVows(db)
            val vow = queryVow(db, vowId) ?: run {
                Log.d(TAG, "Vow #$vowId not active — skipping")
                return
            }
            val nickname = queryUserNickname(db)
            verifyVow(vow, db, nickname)
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

    /** Returns the single active vow with [vowId], or null if not found / not active. */
    private fun queryVow(db: SQLiteDatabase, vowId: Long): VowRow? {
        db.rawQuery(
            "SELECT id, title, pledge_type, condition_json, penalty_amount " +
                "FROM vows WHERE id = ? AND status = 'active'",
            arrayOf(vowId.toString()),
        ).use { c ->
            if (!c.moveToFirst()) return null
            return VowRow(
                id = c.getLong(0),
                title = c.getString(1),
                pledgeType = c.getString(2),
                conditionJson = c.getString(3),
                penaltyAmount = c.getLong(4),
            )
        }
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

        if (passed) {
            postSuccessNotification(
                notifId = (3000 + vow.id).toInt(),
                vowTitle = vow.title,
            )
            // Reschedule this vow's alarm for the same time tomorrow
            scheduleVowAlarm(applicationContext, vow.id, vow.conditionJson)
        } else {
            insertViolation(db, vow.id, verificationId, vow.penaltyAmount)
            updateVowStatus(db, vow.id, "violated")
            postViolationNotification(
                notifId = (2000 + vow.id).toInt(),
                vowTitle = vow.title,
                penaltyAmount = vow.penaltyAmount,
                vowId = vow.id,
                nickname = nickname,
            )
            // Do NOT reschedule — vow is violated, alarm stops
        }
    }

    // ── Type-specific checks ──────────────────────────────────

    private fun verifyUsageBased(condition: JSONObject, type: String): Pair<Boolean, Long> {
        val hasDurationLimit = condition.optBoolean("hasDurationLimit", true)
        val windowStart = condition.optInt("windowStartHour", -1)
        val windowEnd = condition.optInt("windowEndHour", -1)
        val hasWindow = windowStart >= 0 && windowEnd >= 0

        val packageNames: List<String> = condition.optJSONArray("targetApps")
            ?.let { arr -> (0 until arr.length()).map { arr.getString(it) } }
            ?: emptyList()

        if (hasWindow) {
            val (winStartMs, winEndMs) = getWindowTimeRange(windowStart, windowEnd)
            val usedInWindow = getAppUsageInWindowMinutes(packageNames, winStartMs, winEndMs)
            if (!hasDurationLimit) {
                // Window-only: any usage inside the forbidden window = violation
                return Pair(usedInWindow == 0L, usedInWindow)
            }
            // Both window + daily limit: window violation fails immediately
            if (usedInWindow > 0) return Pair(false, usedInWindow)
        }

        if (!hasDurationLimit) return Pair(true, 0L)

        val targetValue = condition.optDouble("targetValue", 0.0)
        val limitMinutes = (targetValue * 60).toLong()

        val usedMinutes = if (packageNames.isEmpty()) {
            getTotalUsageTodayMinutes()
        } else {
            packageNames.sumOf { getAppUsageTodayMinutes(it) }
        }

        return Pair(usedMinutes <= limitMinutes, usedMinutes)
    }

    private fun verifyDelivery(condition: JSONObject): Pair<Boolean, Long> {
        val deliveryApps = listOf(
            "com.woowa.client.android",   // 배달의민족
            "com.coupang.mobile.eats",    // 쿠팡이츠
            "kr.co.yogiyo.rokittech",     // 요기요
        )
        val targetValue = condition.optDouble("targetValue", 0.0).toLong()
        val (startMs, endMs) = getYesterdayRange()
        val launches = countAppLaunchesInPeriod(deliveryApps, startMs, endMs).toLong()
        return Pair(launches <= targetValue, launches)
    }

    // ── UsageStats helpers ────────────────────────────────────

    /**
     * Returns [yesterdayMidnight, todayMidnight] in milliseconds.
     * Verification runs at midnight, so "the day being verified" is yesterday.
     */
    private fun getYesterdayRange(): Pair<Long, Long> {
        val todayMidnight = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val yesterdayMidnight = todayMidnight - 24 * 60 * 60 * 1000L
        return Pair(yesterdayMidnight, todayMidnight)
    }

    /**
     * Returns [startMs, endMs] for the forbidden window on the day being verified.
     * For crossing-midnight windows (endHour ≤ startHour) the end is capped at
     * today's midnight — the post-midnight portion is checked the following night.
     */
    private fun getWindowTimeRange(startHour: Int, endHour: Int): Pair<Long, Long> {
        val (yesterdayMidnight, todayMidnight) = getYesterdayRange()
        val windowStartMs = yesterdayMidnight + startHour * 60 * 60 * 1000L
        val windowEndMs = if (endHour <= startHour) {
            // Crosses midnight: end is today at endHour (alarm fires at endHour:01)
            todayMidnight + endHour * 60 * 60 * 1000L
        } else {
            yesterdayMidnight + endHour * 60 * 60 * 1000L
        }
        return Pair(windowStartMs, windowEndMs)
    }

    /** Total foreground minutes for [packageName] on the day being verified. */
    private fun getAppUsageTodayMinutes(packageName: String): Long {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager ?: return 0L
        val (startMs, endMs) = getYesterdayRange()
        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startMs, endMs)
        val ms = stats?.find { it.packageName == packageName }
            ?.totalTimeInForeground ?: 0L
        return ms / 60_000L
    }

    /** Total foreground minutes across all apps on the day being verified. */
    private fun getTotalUsageTodayMinutes(): Long {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager ?: return 0L
        val (startMs, endMs) = getYesterdayRange()
        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, startMs, endMs)
        return (stats?.sumOf { it.totalTimeInForeground } ?: 0L) / 60_000L
    }

    /**
     * Foreground minutes in [packageNames] within [windowStartMs, windowEndMs].
     * Uses queryEvents for precise sub-day ranges.
     * Empty [packageNames] matches all packages.
     */
    private fun getAppUsageInWindowMinutes(
        packageNames: List<String>,
        windowStartMs: Long,
        windowEndMs: Long,
    ): Long {
        if (windowStartMs >= windowEndMs) return 0L
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager ?: return 0L
        val events = usm.queryEvents(windowStartMs, windowEndMs)
        val event = UsageEvents.Event()
        var foregroundStart: Long? = null
        var totalMs = 0L

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (packageNames.isNotEmpty() && event.packageName !in packageNames) continue
            when (event.eventType) {
                UsageEvents.Event.MOVE_TO_FOREGROUND -> {
                    foregroundStart = maxOf(event.timeStamp, windowStartMs)
                }
                UsageEvents.Event.MOVE_TO_BACKGROUND -> {
                    if (foregroundStart != null) {
                        totalMs += minOf(event.timeStamp, windowEndMs) - foregroundStart
                        foregroundStart = null
                    }
                }
            }
        }
        // App was still in foreground at end of window
        if (foregroundStart != null) {
            totalMs += windowEndMs - foregroundStart
        }
        return maxOf(0L, totalMs) / 60_000L
    }

    /**
     * Number of MOVE_TO_FOREGROUND events for [packageNames] in [startMs, endMs].
     * Used for delivery app launch-count enforcement.
     */
    private fun countAppLaunchesInPeriod(
        packageNames: List<String>,
        startMs: Long,
        endMs: Long,
    ): Int {
        if (startMs >= endMs) return 0
        val usm = getSystemService(Context.USAGE_STATS_SERVICE)
            as? UsageStatsManager ?: return 0
        val events = usm.queryEvents(startMs, endMs)
        val event = UsageEvents.Event()
        var count = 0
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.packageName in packageNames &&
                event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                count++
            }
        }
        return count
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
            NotificationChannel(
                CH_SUCCESS, "서약 달성",
                NotificationManager.IMPORTANCE_DEFAULT,
            ).apply { description = "오늘 서약을 지켰습니다" },
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

    private fun postSuccessNotification(notifId: Int, vowTitle: String) {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val notif = NotificationCompat.Builder(this, CH_SUCCESS)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(vowTitle)
            .setContentText("오늘 해냈습니다")
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .build()
        nm.notify(notifId, notif)
    }

    private fun postViolationNotification(
        notifId: Int,
        vowTitle: String,
        penaltyAmount: Long,
        vowId: Long,
        nickname: String = "사용자",
    ) {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val body = "${nickname}님, ${formatAmount(penaltyAmount)} 납부 대상입니다"

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
        private const val CH_SUCCESS = "pledge_success"
        // Per-vow alarm request codes: BASE_ALARM_CODE + vowId
        private const val BASE_ALARM_CODE = 20000

        /**
         * Reads all active vows from the DB and schedules a per-vow alarm for
         * each one. Safe to call multiple times (FLAG_UPDATE_CURRENT replaces
         * existing alarms). Called on app start, after vow creation, and on boot.
         */
        fun scheduleAllActiveVowAlarms(context: Context) {
            val dbFile = java.io.File(context.filesDir, "gunda.sqlite")
            if (!dbFile.exists()) {
                Log.w(TAG, "DB not found — skipping scheduleAllActiveVowAlarms")
                return
            }
            android.database.sqlite.SQLiteDatabase.openDatabase(
                dbFile.absolutePath, null,
                android.database.sqlite.SQLiteDatabase.OPEN_READONLY,
            ).use { db ->
                db.rawQuery(
                    "SELECT id, condition_json FROM vows WHERE status = 'active'",
                    null,
                ).use { c ->
                    while (c.moveToNext()) {
                        val vowId = c.getLong(0)
                        val conditionJson = c.getString(1)
                        scheduleVowAlarm(context, vowId, conditionJson)
                    }
                }
            }
        }

        /**
         * Schedules (or replaces) the alarm for a single vow.
         * The alarm fires at [getVerificationTime] on the next occurrence of that
         * time, carrying the [vowId] as an Intent extra.
         */
        fun scheduleVowAlarm(context: Context, vowId: Long, conditionJson: String) {
            val condition = runCatching { JSONObject(conditionJson) }.getOrNull() ?: return
            val (hour, minute) = getVerificationTime(condition)
            val triggerMs = nextOccurrenceOf(hour, minute)

            val intent = Intent(context, VerificationAlarmReceiver::class.java)
                .putExtra("vowId", vowId)
            val pi = PendingIntent.getBroadcast(
                context,
                (BASE_ALARM_CODE + vowId).toInt(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
            val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            am.setExact(AlarmManager.RTC_WAKEUP, triggerMs, pi)
            Log.i(TAG, "Vow #$vowId alarm set for $hour:${minute.toString().padStart(2,'0')}")
        }

        /**
         * Returns the (hour, minute) at which this vow should be verified.
         * Window-based: fires 1 minute after the window closes.
         * Duration/count/no-window: fires at 08:01 (morning).
         */
        fun getVerificationTime(condition: JSONObject): Pair<Int, Int> {
            val windowEnd = condition.optInt("windowEndHour", -1)
            return if (windowEnd >= 0) Pair(windowEnd, 1) else Pair(8, 1)
        }

        /**
         * Returns the epoch-ms of the next wall-clock occurrence of [hour]:[minute].
         * If that time has already passed today, returns tomorrow's occurrence.
         */
        fun nextOccurrenceOf(hour: Int, minute: Int): Long {
            val cal = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, hour)
                set(Calendar.MINUTE, minute)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }
            if (cal.timeInMillis <= System.currentTimeMillis()) {
                cal.add(Calendar.DAY_OF_YEAR, 1)
            }
            return cal.timeInMillis
        }
    }
}
