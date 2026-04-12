import '../../domain/models/behavioral_insight.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/domain_violation.dart';

/// Derive behavioral patterns from a vow's violation history.
///
/// Pure synchronous use case — no I/O. Takes the already-fetched
/// violation list and computes streak + trend data.
///
/// Design intent (Beeminder-style):
///   - Surface streak so users feel loss aversion before violating
///   - Surface trend hook for future AI/ML pattern detection
class ComputeBehavioralInsight {
  const ComputeBehavioralInsight();

  BehavioralInsight call(
    List<DomainViolation> violations,
    ContractDateRange period,
  ) {
    if (violations.isEmpty) {
      // No violations → streak = every day since the vow started
      return BehavioralInsight(
        currentStreakDays: period.elapsedDays,
        timeSinceLastViolation: null,
        totalViolations: 0,
        trend: ViolationTrend.unknown,
      );
    }

    // violations is ordered newest-first (from watchViolations)
    final mostRecent = violations.first;
    final timeSince = DateTime.now().difference(mostRecent.violatedAt);
    final streakDays = timeSince.inDays;

    final trend = _computeTrend(violations);

    return BehavioralInsight(
      currentStreakDays: streakDays,
      timeSinceLastViolation: timeSince,
      totalViolations: violations.length,
      trend: trend,
    );
  }

  /// Very simple trend: compare frequency of recent 7 days vs previous 7.
  /// Returns [ViolationTrend.unknown] when insufficient data (< 2 violations).
  ViolationTrend _computeTrend(List<DomainViolation> violations) {
    if (violations.length < 2) return ViolationTrend.unknown;

    final now = DateTime.now();
    final last7 = violations
        .where((v) => now.difference(v.violatedAt).inDays < 7)
        .length;
    final prev7 = violations
        .where((v) {
          final days = now.difference(v.violatedAt).inDays;
          return days >= 7 && days < 14;
        })
        .length;

    if (last7 > prev7) return ViolationTrend.increasing;
    if (last7 < prev7) return ViolationTrend.decreasing;
    return ViolationTrend.stable;
  }
}
