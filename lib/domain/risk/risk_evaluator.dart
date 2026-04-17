import '../../shared/models/enums.dart';
import '../models/contract_terms.dart';
import 'risk_level.dart';
import 'risk_signal.dart';

/// Pure, stateless risk evaluation engine.
///
/// Takes a [ContractTerms] and a [RiskSignal] and returns a
/// [RiskSnapshot]. No I/O, no Flutter, no Riverpod.
/// Fully unit-testable in isolation.
class RiskEvaluator {
  const RiskEvaluator();

  RiskSnapshot evaluate(ContractTerms terms, RiskSignal signal) {
    final condition = terms.condition;
    final consequence = terms.penalty.consequenceLabel;

    // ── Window-only screenTime ─────────────────────────
    if (condition.type == VowType.screenTime &&
        !condition.hasDurationLimit &&
        condition.windowStartHour != null &&
        condition.windowEndHour != null) {
      final inWindow = _inWindow(
        signal.currentHour,
        condition.windowStartHour!,
        condition.windowEndHour!,
      );
      return inWindow
          ? RiskSnapshot(
              level: RiskLevel.danger,
              statusLabel: 'DANGER',
              remainingLabel: '금지 시간대 진행 중',
              consequenceLabel: consequence,
              hasLiveData: true,
            )
          : RiskSnapshot(
              level: RiskLevel.safe,
              statusLabel: 'SAFE ✓',
              remainingLabel: '금지 시간대 아님',
              consequenceLabel: consequence,
              hasLiveData: true,
            );
    }

    // ── Usage-based (screenTime duration, game) ────────
    if (condition.type == VowType.screenTime ||
        condition.type == VowType.game) {
      if (!signal.hasUsageData) {
        return RiskSnapshot.noData(consequenceLabel: consequence);
      }

      if (!condition.hasDurationLimit) {
        return RiskSnapshot.noData(consequenceLabel: consequence);
      }

      final usageNow = signal.usageMinutesNow!;
      final limitMin = (condition.targetValue * 60).round();

      // Complete ban
      if (limitMin == 0) {
        final level =
            usageNow > 0 ? RiskLevel.danger : RiskLevel.safe;
        return RiskSnapshot(
          level: level,
          statusLabel: level == RiskLevel.danger ? 'DANGER' : 'SAFE ✓',
          remainingLabel: level == RiskLevel.danger
              ? '완전 금지 위반 — ${_fmtMin(usageNow)} 사용됨'
              : '완전 금지 — 아직 사용 없음',
          consequenceLabel: consequence,
          hasLiveData: true,
        );
      }

      final remaining = limitMin - usageNow;

      // Optional window constraint on top of duration
      final inWindow = condition.windowStartHour != null &&
              condition.windowEndHour != null
          ? _inWindow(
              signal.currentHour,
              condition.windowStartHour!,
              condition.windowEndHour!,
            )
          : false;

      final RiskLevel level;
      if (remaining <= 0 || inWindow) {
        level = RiskLevel.danger;
      } else if (remaining < limitMin * 0.2) {
        level = RiskLevel.warning;
      } else {
        level = RiskLevel.safe;
      }

      final String statusLabel = switch (level) {
        RiskLevel.safe => 'SAFE ✓',
        RiskLevel.warning => 'WARNING',
        RiskLevel.danger => 'DANGER',
      };

      final String remainingLabel;
      if (remaining <= 0) {
        remainingLabel = '한도 ${_fmtMin(-remaining)} 초과';
      } else if (inWindow) {
        remainingLabel = '금지 시간대 진행 중';
      } else {
        remainingLabel = '오늘 ${_fmtMin(remaining)} 남음';
      }

      return RiskSnapshot(
        level: level,
        statusLabel: statusLabel,
        remainingLabel: remainingLabel,
        consequenceLabel: consequence,
        hasLiveData: true,
      );
    }

    // ── All other types — no live sensor data ──────────
    return RiskSnapshot.noData(consequenceLabel: consequence);
  }

  // ── Helpers ──────────────────────────────────────────

  /// True if [hour] falls in [start, end). Handles overnight windows.
  static bool _inWindow(int hour, int start, int end) {
    if (start < end) return hour >= start && hour < end;
    return hour >= start || hour < end; // overnight e.g. 23→7
  }

  static String _fmtMin(int minutes) {
    if (minutes < 60) return '$minutes분';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '$h시간' : '$h시간 ${m}분';
  }
}
