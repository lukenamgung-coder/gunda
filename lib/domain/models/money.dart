/// Immutable value object — Korean Won amounts.
///
/// All business logic that touches money uses this type
/// rather than raw ints so the unit is never ambiguous.
class Money {
  final int amountKrw;

  const Money(this.amountKrw);

  static const zero = Money(0);

  /// "10,000원"
  String get formatted => '${amountKrw.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      )}원';

  /// "초과 시 → 10,000원 즉시 송금"
  String get consequenceLabel => '초과 시 → $formatted 즉시 송금';

  bool get isZero => amountKrw == 0;

  Money operator +(Money other) => Money(amountKrw + other.amountKrw);

  @override
  bool operator ==(Object other) =>
      other is Money && amountKrw == other.amountKrw;

  @override
  int get hashCode => amountKrw.hashCode;

  @override
  String toString() => formatted;
}
