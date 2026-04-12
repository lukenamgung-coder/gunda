import 'money.dart';

/// Immutable snapshot of a vow's verification/violation statistics.
class VowStats {
  final int totalVerifications;
  final int passedVerifications;
  final Money totalFinesPaid;

  const VowStats({
    required this.totalVerifications,
    required this.passedVerifications,
    required this.totalFinesPaid,
  });

  static const empty = VowStats(
    totalVerifications: 0,
    passedVerifications: 0,
    totalFinesPaid: Money.zero,
  );

  int get violationCount =>
      (totalVerifications - passedVerifications).clamp(0, totalVerifications);

  @override
  bool operator ==(Object other) =>
      other is VowStats &&
      totalVerifications == other.totalVerifications &&
      passedVerifications == other.passedVerifications &&
      totalFinesPaid == other.totalFinesPaid;

  @override
  int get hashCode =>
      Object.hash(totalVerifications, passedVerifications, totalFinesPaid);
}
