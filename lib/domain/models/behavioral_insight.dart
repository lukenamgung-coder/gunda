/// Behavioral pattern derived from a vow's violation history.
///
/// Pure computed value — no I/O, no side effects.
/// Designed to surface streak pressure and trend awareness.
class BehavioralInsight {
  /// Days since the last violation (or days elapsed if no violations).
  final int currentStreakDays;

  /// Wall-clock duration since the most recent violation.
  /// Null when the vow has never been violated.
  final Duration? timeSinceLastViolation;

  /// Total number of violations in this vow's lifetime.
  final int totalViolations;

  /// Hook for future risk trend (increasing / stable / decreasing).
  /// Reserved — always null in MVP.
  final ViolationTrend trend;

  const BehavioralInsight({
    required this.currentStreakDays,
    required this.timeSinceLastViolation,
    required this.totalViolations,
    this.trend = ViolationTrend.unknown,
  });

  static const clean = BehavioralInsight(
    currentStreakDays: 0,
    timeSinceLastViolation: null,
    totalViolations: 0,
  );

  bool get hasActiveStreak => currentStreakDays > 0;
  bool get hasBeenViolated => totalViolations > 0;

  /// "23일 연속 준수 중" / "오늘 위반" / "연속 기록 없음"
  String get streakLabel {
    if (currentStreakDays == 0) return '오늘 위반';
    if (currentStreakDays == 1) return '1일 연속 준수 중';
    return '$currentStreakDays일 연속 준수 중';
  }

  /// "마지막 위반: 3일 전" — null when no violations yet.
  String? get lastViolationLabel {
    if (timeSinceLastViolation == null) return null;
    final days = timeSinceLastViolation!.inDays;
    final hours = timeSinceLastViolation!.inHours;
    if (days >= 1) return '마지막 위반: $days일 전';
    if (hours >= 1) return '마지막 위반: $hours시간 전';
    return '마지막 위반: 방금 전';
  }
}

/// Hook for future AI-driven risk trend analysis.
enum ViolationTrend {
  increasing, // Violations are becoming more frequent
  stable,     // Frequency unchanged
  decreasing, // User is improving
  unknown,    // Insufficient data
}
