import 'package:flutter/services.dart';

/// Dart bridge to the Kotlin AlarmManager scheduler.
///
/// Calling [scheduleNightly] instructs [PledgeMonitorService] (via
/// MethodChannel) to register an exact alarm for the next midnight.
/// The Kotlin side silently replaces any previously set alarm, so
/// calling this on every cold-start is idempotent and safe.
class VerificationScheduleService {
  VerificationScheduleService._();

  static const _channel =
      MethodChannel('com.gunda.app/schedule');

  /// Register (or refresh) the nightly midnight alarm.
  /// Must be called after [WidgetsFlutterBinding.ensureInitialized()].
  static Future<void> scheduleNightly() async {
    try {
      await _channel.invokeMethod<void>('scheduleNightly');
    } on PlatformException catch (e) {
      // Non-fatal — alarm scheduling may fail if SCHEDULE_EXACT_ALARM
      // is not granted on Android 12+. The service will still run
      // when launched manually or via BootReceiver on Android <12.
      // ignore: avoid_print
      print('[VerificationScheduleService] scheduleNightly failed: $e');
    }
  }
}
