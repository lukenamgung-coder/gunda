/// Inputs to the risk evaluation system.
///
/// Aggregates sensor/device data before passing to [RiskEvaluator].
/// Adding a new signal type (e.g. heart-rate, GPS) only requires
/// extending this class — the evaluator contract stays stable.
class RiskSignal {
  /// Today's device usage in minutes for the relevant app(s).
  /// Null when permission is denied or data is unavailable.
  final int? usageMinutesNow;

  /// Current hour of day (0–23). Used for window-based evaluation.
  final int currentHour;

  const RiskSignal({
    this.usageMinutesNow,
    required this.currentHour,
  });

  /// Snapshot captured right now.
  factory RiskSignal.now({int? usageMinutesNow}) => RiskSignal(
        usageMinutesNow: usageMinutesNow,
        currentHour: DateTime.now().hour,
      );

  bool get hasUsageData => usageMinutesNow != null;
}
