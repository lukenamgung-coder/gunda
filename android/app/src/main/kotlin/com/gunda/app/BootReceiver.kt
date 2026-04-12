package com.gunda.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Re-schedules the nightly verification alarm after device reboot.
 * The AlarmManager queue is cleared on reboot, so we must reschedule here.
 */
class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            PledgeMonitorService.scheduleNextMidnight(context)
        }
    }
}
