import '../../shared/models/enums.dart';
import 'contract_terms.dart';
import 'enforcer.dart';
import 'vow_stats.dart';

/// Aggregate root — the behavioral contract.
///
/// This is the core domain object for the vow detail feature.
/// All business state is expressed here; widgets receive this
/// object and render it — they own no logic themselves.
class ContractVow {
  final int id;
  final String title;
  final VowStatus status;
  final ContractTerms terms;
  final Enforcer enforcer;
  final VowStats stats;

  const ContractVow({
    required this.id,
    required this.title,
    required this.status,
    required this.terms,
    required this.enforcer,
    required this.stats,
  });

  bool get isActive => status == VowStatus.active;
  bool get isCompleted => status == VowStatus.completed;
  bool get isViolated => status == VowStatus.violated;
  bool get isPaused => status == VowStatus.paused;

  /// Human-readable status label in Korean.
  String get statusLabel => switch (status) {
        VowStatus.active => '진행 중',
        VowStatus.completed => '완료',
        VowStatus.violated => '위반',
        VowStatus.paused => '일시 중지',
      };

  ContractVow copyWith({VowStatus? status}) => ContractVow(
        id: id,
        title: title,
        status: status ?? this.status,
        terms: terms,
        enforcer: enforcer,
        stats: stats,
      );

  @override
  bool operator ==(Object other) =>
      other is ContractVow &&
      id == other.id &&
      status == other.status &&
      stats == other.stats;

  @override
  int get hashCode => Object.hash(id, status, stats);

  @override
  String toString() => 'ContractVow(#$id "$title" $status)';
}
