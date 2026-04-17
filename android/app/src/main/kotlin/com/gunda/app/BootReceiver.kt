package com.gunda.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Re-schedules per-vow verification alarms after device reboot.
 * The AlarmManager queue is cleared on reboot, so we must re-register here.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            VowMonitorService.scheduleAllActiveVowAlarms(context)
        }
    }
}
