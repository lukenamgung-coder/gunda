import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Dart-side notification wrapper.
///
/// Handles channel registration and app-side violation alerts.
/// Background violations are notified directly by VowMonitorService (Kotlin).
/// This service covers:
///   - Initialisation (channel setup, permission request)
///   - In-app violation alerts triggered from Dart (e.g. custom-type vow checks)
///   - Notification tap → deep navigation via payload
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  static const _violationChannelId = 'violations';
  static const _violationChannelName = '서약 위반';

  static const _androidChannel = AndroidNotificationChannel(
    _violationChannelId,
    _violationChannelName,
    description: '서약 위반 감지 및 납부 안내',
    importance: Importance.high,
  );

  /// Call once from main() before runApp().
  Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onTap,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);
  }

  /// Shows a violation alert. Tapping navigates to the vow detail screen.
  Future<void> showViolationAlert({
    required int notificationId,
    required String vowTitle,
    required int penaltyAmount,
    required int vowId,
  }) async {
    final body = '위반 1회 — ${_formatAmount(penaltyAmount)} 송금 대상';
    await _plugin.show(
      notificationId,
      '$vowTitle — 계약 위반',
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _violationChannelId,
          _violationChannelName,
          channelDescription: '서약 위반 감지 및 납부 안내',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: '/home/vow/$vowId',
    );
  }

  void _onTap(NotificationResponse response) {
    // Navigation is handled at the app level via the payload string.
    // The router listener picks this up via notificationTapRouteProvider.
    _pendingRoute = response.payload;
  }

  /// Consumed once by the router on app resume.
  String? _pendingRoute;
  String? consumePendingRoute() {
    final r = _pendingRoute;
    _pendingRoute = null;
    return r;
  }

  String _formatAmount(int amount) {
    final buf = StringBuffer();
    final s = amount.toString();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return '${buf}원';
  }
}
