package com.gunda.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.ContextCompat

/**
 * AlarmManager target — wakes the app at midnight and starts
 * [PledgeMonitorService] as a foreground service.
 */
class VerificationAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val serviceIntent = Intent(context, PledgeMonitorService::class.java)
        ContextCompat.startForegroundService(context, serviceIntent)
    }
}
