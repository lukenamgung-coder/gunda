import 'dart:convert';
import 'enums.dart';

/// 서약 조건 모델 (DB에 JSON 문자열로 저장)
class PledgeCondition {
  final PledgeType type;
  final double targetValue;
  final String unit;
  final ConditionOperator operator;

  /// 스크린타임 서약일 때 특정 앱 패키지명 (null = 전체 앱)
  final String? targetApp;

  /// 게임/스크린타임 서약에서 제한할 앱 패키지명 목록
  final List<String>? targetApps;

  /// 스크린타임 전용 — 하루 사용시간 제한 활성 여부
  /// false 이면 targetValue 무시. null → true (하위 호환)
  final bool hasDurationLimit;

  /// 스크린타임 전용 — 금지 시작 시각 (0‑23). null = 시간대 제한 없음
  final int? windowStartHour;

  /// 스크린타임 전용 — 금지 종료 시각 (0‑23). null = 시간대 제한 없음
  final int? windowEndHour;

  const PledgeCondition({
    required this.type,
    required this.targetValue,
    required this.unit,
    required this.operator,
    this.targetApp,
    this.targetApps,
    this.hasDurationLimit = true,
    this.windowStartHour,
    this.windowEndHour,
  });

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'targetValue': targetValue,
        'unit': unit,
        'operator': operator.name,
        if (targetApp != null) 'targetApp': targetApp,
        if (targetApps != null) 'targetApps': targetApps,
        'hasDurationLimit': hasDurationLimit,
        if (windowStartHour != null) 'windowStartHour': windowStartHour,
        if (windowEndHour != null) 'windowEndHour': windowEndHour,
      };

  factory PledgeCondition.fromJson(Map<String, dynamic> json) {
    return PledgeCondition(
      type: PledgeType.values.byName(json['type'] as String),
      targetValue: (json['targetValue'] as num).toDouble(),
      unit: json['unit'] as String,
      operator:
          ConditionOperator.values.byName(json['operator'] as String),
      targetApp: json['targetApp'] as String?,
      targetApps: (json['targetApps'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasDurationLimit: json['hasDurationLimit'] as bool? ?? true,
      windowStartHour: json['windowStartHour'] as int?,
      windowEndHour: json['windowEndHour'] as int?,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory PledgeCondition.fromJsonString(String s) =>
      PledgeCondition.fromJson(jsonDecode(s) as Map<String, dynamic>);

  /// 사람이 읽기 쉬운 조건 설명
  String toDisplayString() {
    switch (type) {
      case PledgeType.screenTime:
        final durStr = hasDurationLimit
            ? (targetValue == 0
                ? '완전 금지'
                : _fmtHoursDisplay(targetValue))
            : null;
        final winStr = (windowStartHour != null && windowEndHour != null)
            ? '$windowStartHour시 ~ $windowEndHour시 금지'
            : null;
        if (durStr == '완전 금지') return '완전 금지';
        if (durStr != null && winStr != null) return '$durStr + $winStr';
        if (durStr != null) return durStr;
        if (winStr != null) return winStr;
        return '조건 없음';

      case PledgeType.delivery:
        if (targetValue == 0) return '완전 금지';
        return '하루 ${targetValue.toInt()}회 이하';

      case PledgeType.game:
        if (targetValue == 0) return '완전 금지';
        return '하루 ${targetValue.toInt()}분 이하';

      default:
        final opLabel = switch (operator) {
          ConditionOperator.lte => '이하',
          ConditionOperator.gte => '이상',
          ConditionOperator.eq => '정확히',
        };
        final valueStr = targetValue == targetValue.truncateToDouble()
            ? targetValue.toInt().toString()
            : targetValue.toString();
        return '$valueStr $unit $opLabel';
    }
  }

  static String _fmtHoursDisplay(double h) {
    final hrs = h.floor();
    final mins = ((h - hrs) * 60).round();
    if (hrs == 0) return '$mins분 이하';
    if (mins == 0) return '$hrs시간 이하';
    return '$hrs시간 ${mins}분 이하';
  }

  /// 기본 조건 프리셋
  static PledgeCondition defaultFor(PledgeType type) {
    return switch (type) {
      PledgeType.screenTime => const PledgeCondition(
          type: PledgeType.screenTime,
          targetValue: 2,
          unit: '시간',
          operator: ConditionOperator.lte,
          hasDurationLimit: true,
        ),
      PledgeType.sleep => const PledgeCondition(
          type: PledgeType.sleep,
          targetValue: 7,
          unit: '시간',
          operator: ConditionOperator.gte,
        ),
      PledgeType.steps => const PledgeCondition(
          type: PledgeType.steps,
          targetValue: 10000,
          unit: '걸음',
          operator: ConditionOperator.gte,
        ),
      PledgeType.exercise => const PledgeCondition(
          type: PledgeType.exercise,
          targetValue: 30,
          unit: '분',
          operator: ConditionOperator.gte,
        ),
      PledgeType.delivery => const PledgeCondition(
          type: PledgeType.delivery,
          targetValue: 0,
          unit: '회',
          operator: ConditionOperator.lte,
        ),
      PledgeType.game => const PledgeCondition(
          type: PledgeType.game,
          targetValue: 60,
          unit: '분',
          operator: ConditionOperator.lte,
        ),
      PledgeType.custom => const PledgeCondition(
          type: PledgeType.custom,
          targetValue: 1,
          unit: '회',
          operator: ConditionOperator.gte,
        ),
    };
  }
}
