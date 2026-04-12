import 'package:flutter/services.dart';

/// MethodChannel 래퍼 — UsageStatsManager + PackageManager
///
/// Android 전용. 권한이 없으면 [checkPermission]이 false를 반환하므로
/// 각 메서드 호출 전 반드시 권한 확인 후 설정 화면으로 안내하세요.
class UsageStatsService {
  UsageStatsService._();

  static const _ch =
      MethodChannel('com.gunda.app/usage_stats');

  // ── 권한 ────────────────────────────────────────────────

  /// PACKAGE_USAGE_STATS 권한 허용 여부
  static Future<bool> checkPermission() async {
    final ok = await _ch.invokeMethod<bool>('checkPermission');
    return ok ?? false;
  }

  /// 앱 사용 정보 접근 설정 화면으로 이동
  static Future<void> openUsageAccessSettings() async {
    await _ch.invokeMethod('openUsageAccessSettings');
  }

  // ── 사용 시간 ────────────────────────────────────────────

  /// 오늘(자정~현재) 특정 앱의 사용 시간 (분)
  ///
  /// [packageName]을 생략하면 **전체 앱 합산** 시간 반환.
  /// 권한 없으면 -1 반환.
  static Future<int> getAppUsageToday({
    String? packageName,
  }) async {
    final minutes = await _ch.invokeMethod<int>(
      'getAppUsageToday',
      packageName != null
          ? {'packageName': packageName}
          : null,
    );
    return minutes ?? 0;
  }

  /// 특정 앱의 마지막 사용 시각.
  ///
  /// 사용 이력이 없거나 권한이 없으면 null 반환.
  static Future<DateTime?> getLastUsedTime(
      String packageName) async {
    final ms = await _ch.invokeMethod<int>(
      'getLastUsedTime',
      {'packageName': packageName},
    );
    if (ms == null || ms < 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  // ── 게임 앱 목록 ─────────────────────────────────────────

  /// CATEGORY_GAME 또는 FLAG_IS_GAME 기준으로 설치된 게임 앱 반환.
  ///
  /// 아이콘은 48×48 PNG ByteArray (null 가능).
  static Future<List<InstalledApp>> getInstalledGames() async {
    final raw =
        await _ch.invokeListMethod<Map>('getInstalledGames');
    return (raw ?? []).map(InstalledApp._fromMap).toList();
  }

  // ── 사용자 앱 목록 (시스템 앱 제외) ──────────────────────

  /// 설치된 사용자 앱 전체 반환 (시스템 앱·자기 앱 제외, 아이콘 없음).
  static Future<List<InstalledApp>> getInstalledUserApps() async {
    final raw =
        await _ch.invokeListMethod<Map>('getInstalledUserApps');
    return (raw ?? []).map(InstalledApp._fromMap).toList();
  }
}

/// 설치된 앱 정보 모델
class InstalledApp {
  final String packageName;
  final String appName;

  /// 48×48 PNG 바이트. Dart 측 Image.memory()로 표시 가능.
  final Uint8List? icon;

  const InstalledApp({
    required this.packageName,
    required this.appName,
    this.icon,
  });

  factory InstalledApp._fromMap(Map m) => InstalledApp(
        packageName: m['packageName'] as String,
        appName: m['appName'] as String,
        icon: m['icon'] != null
            ? Uint8List.fromList(
                List<int>.from(m['icon'] as List))
            : null,
      );

  @override
  String toString() =>
      'InstalledApp($packageName, $appName)';
}
