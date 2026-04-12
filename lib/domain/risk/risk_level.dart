/// Output of the risk evaluation system.

enum RiskLevel { safe, warning, danger }

/// A point-in-time risk snapshot for a single vow.
///
/// Pure data — no formatting logic, no Flutter deps.
class RiskSnapshot {
  final RiskLevel level;

  /// Display label: "SAFE ✓" / "WARNING" / "DANGER"
  final String statusLabel;

  /// Remaining buffer: "오늘 37분 남음" — null when no live data.
  final String? remainingLabel;

  /// Consequence sentence: "초과 시 → 10,000원 즉시 송금"
  final String consequenceLabel;

  /// False when device data was unavailable (no permission, unsupported type).
  final bool hasLiveData;

  const RiskSnapshot({
    required this.level,
    required this.statusLabel,
    required this.remainingLabel,
    required this.consequenceLabel,
    required this.hasLiveData,
  });

  /// Convenience constructor when no live data is available.
  const RiskSnapshot.noData({required String consequenceLabel})
      : level = RiskLevel.safe,
        statusLabel = 'SAFE ✓',
        remainingLabel = null,
        consequenceLabel = consequenceLabel,
        hasLiveData = false;
}
