/// The third party who receives money when the user fails.
///
/// Replaces the fragile `"name|phone|relationship"` string
/// that was parsed inside widget build() methods.
class Enforcer {
  final String name;
  final String phone;
  final String relationship;

  const Enforcer({
    required this.name,
    this.phone = '',
    this.relationship = '',
  });

  /// Parses the DB storage format: `"홍길동|010-1234-5678|친구"`
  factory Enforcer.fromStorageString(String? raw) {
    if (raw == null || raw.trim().isEmpty) return Enforcer.unknown;
    final parts = raw.split('|');
    return Enforcer(
      name: parts.isNotEmpty ? parts[0].trim() : '',
      phone: parts.length > 1 ? parts[1].trim() : '',
      relationship: parts.length > 2 ? parts[2].trim() : '',
    );
  }

  static const unknown = Enforcer(name: '미지정');

  bool get isUnknown => name.isEmpty || name == '미지정';
  bool get hasPhone => phone.isNotEmpty;

  /// "홍길동 (친구)"
  String get displayName =>
      relationship.isEmpty ? name : '$name ($relationship)';

  /// Storage round-trip.
  String toStorageString() => '$name|$phone|$relationship';

  @override
  bool operator ==(Object other) =>
      other is Enforcer &&
      name == other.name &&
      phone == other.phone &&
      relationship == other.relationship;

  @override
  int get hashCode => Object.hash(name, phone, relationship);

  @override
  String toString() => 'Enforcer($displayName)';
}
