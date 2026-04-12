/// Immutable date range value object.
///
/// All D-day / progress calculations live here,
/// not in widget build() methods.
class ContractDateRange {
  final DateTime start;
  final DateTime end;

  const ContractDateRange({required this.start, required this.end});

  /// Total days in the contract (inclusive).
  int get totalDays => end.difference(start).inDays + 1;

  /// Days remaining until end (clamped to [0, totalDays]).
  int get daysLeft =>
      end.difference(DateTime.now()).inDays.clamp(0, totalDays);

  /// Days elapsed since start (clamped to [0, totalDays]).
  int get elapsedDays => (totalDays - daysLeft).clamp(0, totalDays);

  /// 0.0 → 1.0 progress ratio.
  double get progressRatio =>
      totalDays > 0 ? elapsedDays / totalDays : 0.0;

  bool get isExpired => DateTime.now().isAfter(end);

  static String _pad(int v) => v.toString().padLeft(2, '0');

  String _fmt(DateTime d) =>
      '${d.year}.${_pad(d.month)}.${_pad(d.day)}';

  /// "2025.01.01 ~ 2025.01.31 (31일)"
  String get summaryLabel =>
      '${_fmt(start)} ~ ${_fmt(end)}  ($totalDays일)';

  @override
  bool operator ==(Object other) =>
      other is ContractDateRange &&
      start == other.start &&
      end == other.end;

  @override
  int get hashCode => Object.hash(start, end);
}
