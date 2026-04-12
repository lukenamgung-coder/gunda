package com.gunda.app

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.os.Build
import android.provider.Settings
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.Calendar

/**
 * MethodChannel: com.gunda.app/usage_stats
 *
 * 지원 메서드
 *  - checkPermission()                         → Boolean
 *  - openUsageAccessSettings()                 → null (설정 화면 이동)
 *  - getAppUsageToday({packageName?})          → Long (분, -1 = 권한 없음)
 *  - getLastUsedTime({packageName})            → Long (Unix ms, -1 = 없음)
 *  - getInstalledGames()                       → List<Map<packageName, appName, icon?>>
 */
class UsageStatsPlugin(private val context: Context) :
    MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL = "com.gunda.app/usage_stats"
        private const val ICON_SIZE_PX = 48
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkPermission"   -> result.success(hasPermission())
            "openUsageAccessSettings" -> {
                val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                }
                context.startActivity(intent)
                result.success(null)
            }
            "getAppUsageToday"  -> {
                val pkg = call.argument<String>("packageName")
                result.success(getAppUsageToday(pkg))
            }
            "getLastUsedTime"   -> {
                val pkg = call.argument<String>("packageName")
                    ?: return result.error("INVALID_ARGS", "packageName required", null)
                result.success(getLastUsedTime(pkg))
            }
            "getInstalledGames"     -> result.success(getInstalledGames())
            "getInstalledUserApps"  -> result.success(getInstalledUserApps())
            else                    -> result.notImplemented()
        }
    }

    // ── 권한 확인 ─────────────────────────────────────────

    private fun hasPermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(),
                context.packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    // ── 오늘 사용 시간 (분) ───────────────────────────────

    private fun getAppUsageToday(packageName: String?): Long {
        if (!hasPermission()) return -1L

        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val startOfDay = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, 0)
            set(Calendar.MINUTE, 0)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
        }.timeInMillis
        val now = System.currentTimeMillis()

        // INTERVAL_BEST: 주어진 구간에 가장 적합한 집계 단위 선택
        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_BEST, startOfDay, now)

        val totalMs = if (packageName == null) {
            // 전체 앱 합산 (시스템 앱 제외 필터 없음 — 필요 시 추가)
            stats.sumOf { it.totalTimeInForeground }
        } else {
            stats.find { it.packageName == packageName }?.totalTimeInForeground ?: 0L
        }
        return totalMs / 60_000L
    }

    // ── 마지막 사용 시각 ──────────────────────────────────

    private fun getLastUsedTime(packageName: String): Long {
        if (!hasPermission()) return -1L

        val usm = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val startTime = endTime - 7L * 24 * 60 * 60 * 1000 // 최근 7일

        val stats = usm.queryUsageStats(UsageStatsManager.INTERVAL_BEST, startTime, endTime)
        return stats.find { it.packageName == packageName }?.lastTimeUsed ?: -1L
    }

    // ── 설치된 게임 앱 목록 ───────────────────────────────

    private fun getInstalledGames(): List<Map<String, Any?>> {
        val pm = context.packageManager
        val apps = pm.getInstalledApplications(PackageManager.GET_META_DATA)

        return apps
            .filter { info -> isGame(info) }
            .mapNotNull { info ->
                try {
                    val appName = pm.getApplicationLabel(info).toString()
                    val icon = extractIcon(pm, info.packageName)
                    mapOf(
                        "packageName" to info.packageName,
                        "appName"     to appName,
                        "icon"        to icon        // ByteArray? (PNG, 48×48)
                    )
                } catch (_: Exception) {
                    null
                }
            }
    }

    // ── 설치된 사용자 앱 목록 (시스템 앱 제외) ────────────────

    private fun getInstalledUserApps(): List<Map<String, Any?>> {
        val pm = context.packageManager
        return pm.getInstalledApplications(PackageManager.GET_META_DATA)
            .filter { info ->
                (info.flags and ApplicationInfo.FLAG_SYSTEM) == 0 &&
                info.packageName != context.packageName
            }
            .mapNotNull { info ->
                try {
                    mapOf(
                        "packageName" to info.packageName,
                        "appName"     to pm.getApplicationLabel(info).toString()
                    )
                } catch (_: Exception) { null }
            }
            .sortedBy { it["appName"] as String }
    }

    /** CATEGORY_GAME (API 26+) 또는 FLAG_IS_GAME 기준으로 필터링 */
    private fun isGame(info: ApplicationInfo): Boolean {
        val flagGame = (info.flags and ApplicationInfo.FLAG_IS_GAME) != 0
        val categoryGame = info.category == ApplicationInfo.CATEGORY_GAME
        return flagGame || categoryGame
    }

    /** 앱 아이콘을 48×48 PNG ByteArray로 변환 */
    private fun extractIcon(pm: PackageManager, packageName: String): ByteArray? {
        return try {
            val drawable = pm.getApplicationIcon(packageName)
            val source = if (drawable is BitmapDrawable) {
                drawable.bitmap
            } else {
                val w = drawable.intrinsicWidth.coerceAtLeast(1)
                val h = drawable.intrinsicHeight.coerceAtLeast(1)
                val bmp = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(bmp)
                drawable.setBounds(0, 0, w, h)
                drawable.draw(canvas)
                bmp
            }
            val scaled = Bitmap.createScaledBitmap(source, ICON_SIZE_PX, ICON_SIZE_PX, true)
            ByteArrayOutputStream().also { out ->
                scaled.compress(Bitmap.CompressFormat.PNG, 80, out)
            }.toByteArray()
        } catch (_: Exception) {
            null
        }
    }
}
