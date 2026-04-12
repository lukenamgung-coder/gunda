import 'package:health/health.dart';

/// Health Connect 연동 서비스 (걸음수 · 수면)
///
/// 사용 순서:
///   1. [configure] — 앱 시작 시 한 번 호출
///   2. [requestPermissions] — 권한이 없을 때 호출
///   3. [getTodaySteps] / [getLastNightSleepMinutes] — 데이터 조회
class HealthService {
  HealthService._();

  static final _health = Health();
  static bool _configured = false;

  // 걸음수 + 수면 두 타입 모두 요청
  static const _types = [
    HealthDataType.STEPS,
    HealthDataType.SLEEP_SESSION,
  ];

  // ── 초기화 ────────────────────────────────────────────────

  /// Health Connect SDK 초기화.
  /// [main()] 또는 첫 화면 진입 시 한 번 호출하면 됩니다.
  static Future<void> configure() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }

  // ── 권한 ─────────────────────────────────────────────────

  /// Health Connect 권한 요청 (걸음수 + 수면).
  ///
  /// 사용자가 Health Connect 앱에서 권한을 부여해야 하므로
  /// 권한 설명 UI를 먼저 보여준 뒤 호출하세요.
  /// 반환값: true = 전부 허용, false = 일부 거부 또는 오류
  static Future<bool> requestPermissions() async {
    await configure();
    try {
      return await _health.requestAuthorization(
        _types,
        permissions: List.filled(
          _types.length,
          HealthDataAccess.READ,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// 걸음수 권한 허용 여부
  static Future<bool> hasStepsPermission() async {
    await configure();
    return await _health
            .hasPermissions([HealthDataType.STEPS]) ??
        false;
  }

  /// 수면 권한 허용 여부
  static Future<bool> hasSleepPermission() async {
    await configure();
    return await _health.hasPermissions(
            [HealthDataType.SLEEP_SESSION]) ??
        false;
  }

  // ── 걸음수 ───────────────────────────────────────────────

  /// 오늘(자정 ~ 현재) 걸음수.
  ///
  /// 권한이 없으면 [HealthPermissionException] throw.
  /// Health Connect 데이터가 없으면 0 반환.
  static Future<int> getTodaySteps() async {
    await configure();

    if (!await hasStepsPermission()) {
      throw const HealthPermissionException(
        '걸음수 접근 권한이 없습니다.\n설정에서 Health Connect 권한을 허용해주세요.',
      );
    }

    final now = DateTime.now();
    final startOfDay =
        DateTime(now.year, now.month, now.day);
    return await _health.getTotalStepsInInterval(
          startOfDay,
          now,
        ) ??
        0;
  }

  // ── 수면 ─────────────────────────────────────────────────

  /// 어젯밤 수면 시간 (분).
  ///
  /// 조회 범위: 어제 오후 18:00 ~ 오늘 12:00 (자정 전후 수면 포괄).
  /// 여러 수면 세션이 있으면 합산합니다.
  ///
  /// 권한이 없으면 [HealthPermissionException] throw.
  /// 데이터가 없으면 0 반환.
  static Future<int> getLastNightSleepMinutes() async {
    await configure();

    if (!await hasSleepPermission()) {
      throw const HealthPermissionException(
        '수면 데이터 접근 권한이 없습니다.\n설정에서 Health Connect 권한을 허용해주세요.',
      );
    }

    final now = DateTime.now();
    // 오늘 정오를 기준으로 18시간 전(어제 오후 6시) ~ 정오 조회
    final windowEnd =
        DateTime(now.year, now.month, now.day, 12);
    final windowStart =
        windowEnd.subtract(const Duration(hours: 18));

    final rawData = await _health.getHealthDataFromTypes(
      startTime: windowStart,
      endTime: windowEnd,
      types: const [HealthDataType.SLEEP_SESSION],
    );

    if (rawData.isEmpty) return 0;

    // 중복 제거 후 세션 시간 합산
    final sessions = _health.removeDuplicates(rawData);
    final totalMs = sessions.fold<int>(
      0,
      (sum, point) =>
          sum +
          point.dateTo
              .difference(point.dateFrom)
              .inMilliseconds,
    );
    return totalMs ~/ 60_000;
  }
}

// ── 예외 ─────────────────────────────────────────────────────

class HealthPermissionException implements Exception {
  final String message;
  const HealthPermissionException(this.message);

  @override
  String toString() => message;
}
