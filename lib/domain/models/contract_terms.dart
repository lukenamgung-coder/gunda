import '../../shared/models/pledge_condition.dart';
import 'date_range.dart';
import 'money.dart';

/// The binding terms of a behavioral contract.
///
/// Groups the three pillars that define the contract:
/// what you must do (condition), when (period), and
/// what happens if you fail (penalty).
class ContractTerms {
  final PledgeCondition condition;
  final ContractDateRange period;
  final Money penalty;

  const ContractTerms({
    required this.condition,
    required this.period,
    required this.penalty,
  });

  @override
  bool operator ==(Object other) =>
      other is ContractTerms &&
      condition == other.condition &&
      period == other.period &&
      penalty == other.penalty;

  @override
  int get hashCode => Object.hash(condition, period, penalty);
}
