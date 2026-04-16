import 'enums.dart';

/// 온보딩 프리셋에서 서약 만들기 화면으로 전달되는 사전 설정값.
/// GoRouter extra로 전달되며, CreateVowScreen에서 초기 상태를 채운다.
class VowFormPreset {
  final PledgeType type;
  final int durationDays;
  final int penaltyAmount;

  // screenTime
  final List<String> screenTimePackages;
  final bool hasDurationLimit;
  final double screenTimeLimitHours; // 0 = 완전 차단
  final bool hasWindowLimit;
  final int windowStartHour;
  final int windowEndHour;

  // delivery
  final bool deliveryFullBan;
  final int deliveryMaxCount;

  // game: targetValue for daily limit (0 = complete ban).
  // When gameWindowStartHour/EndHour are set, window restriction is active
  // (daily limit is ignored in display; enforcement pending bug fix).
  final double gameTargetMinutes;
  final int? gameWindowStartHour;
  final int? gameWindowEndHour;

  const VowFormPreset({
    required this.type,
    required this.durationDays,
    required this.penaltyAmount,
    this.screenTimePackages = const [],
    this.hasDurationLimit = true,
    this.screenTimeLimitHours = 2.0,
    this.hasWindowLimit = false,
    this.windowStartHour = 23,
    this.windowEndHour = 7,
    this.deliveryFullBan = true,
    this.deliveryMaxCount = 1,
    this.gameTargetMinutes = 60.0,
    this.gameWindowStartHour,
    this.gameWindowEndHour,
  });
}
