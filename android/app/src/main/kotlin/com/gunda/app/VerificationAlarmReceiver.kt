package com.gunda.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

/**
 * AlarmManager target — wakes the app at the vow's verification time and starts
 * [VowMonitorService] as a foreground service for that specific vow.
 *
 * The [vowId] extra identifies which vow to verify. If absent (legacy / fallback),
 * the service verifies all active vows.
 */
class VerificationAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val vowId = intent.getLongExtra("vowId", -1L)
        val serviceIntent = Intent(context, VowMonitorService::class.java)
            .putExtra("vowId", vowId)
        ContextCompat.startForegroundService(context, serviceIntent)
    }
}
