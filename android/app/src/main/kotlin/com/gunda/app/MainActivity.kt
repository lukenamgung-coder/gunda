package com.gunda.app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            UsageStatsPlugin.CHANNEL,
        ).setMethodCallHandler(UsageStatsPlugin(this))

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.gunda.app/schedule",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleAllVows" -> {
                    VowMonitorService.scheduleAllActiveVowAlarms(this)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
