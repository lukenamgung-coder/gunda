import 'package:flutter/services.dart';

/// Dart bridge to the Kotlin AlarmManager scheduler.
///
/// Calling [scheduleAllVows] reads all active vows from the DB and registers
/// a per-vow exact alarm for each one. The Kotlin side uses FLAG_UPDATE_CURRENT,
/// so calling this on every cold-start and after vow creation is idempotent.
class VerificationScheduleService {
  VerificationScheduleService._();

  static const _channel =
      MethodChannel('com.gunda.app/schedule');

  /// Register (or refresh) per-vow alarms for all active vows.
  /// Must be called after [WidgetsFlutterBinding.ensureInitialized()].
  static Future<void> scheduleAllVows() async {
    try {
      await _channel.invokeMethod<void>('scheduleAllVows');
    } on PlatformException catch (e) {
      // Non-fatal — alarm scheduling may fail if SCHEDULE_EXACT_ALARM
      // is not granted on Android 12+.
      // ignore: avoid_print
      print('[VerificationScheduleService] scheduleAllVows failed: $e');
    }
  }
}
