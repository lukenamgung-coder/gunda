import '../../core/services/usage_stats_service.dart';
import '../../domain/models/contract_terms.dart';
import '../../domain/risk/risk_evaluator.dart';
import '../../domain/risk/risk_level.dart';
import '../../domain/risk/risk_signal.dart';
import '../../shared/models/enums.dart';

/// Fetch live sensor data then delegate to [RiskEvaluator].
///
/// This is the only use case with I/O. It isolates the
/// async device-data fetch so [RiskEvaluator] stays pure.
class EvaluateRisk {
  final RiskEvaluator _evaluator;

  const EvaluateRisk([this._evaluator = const RiskEvaluator()]);

  Future<RiskSnapshot> call(ContractTerms terms) async {
    final condition = terms.condition;
    int? usageMin;

    if (condition.type == PledgeType.screenTime ||
        condition.type == PledgeType.game) {
      final hasPermission =
          await UsageStatsService.checkPermission();
      if (hasPermission) {
        final pkgs = condition.targetApps;
        if (pkgs == null || pkgs.isEmpty) {
          usageMin = await UsageStatsService.getAppUsageToday();
        } else {
          var total = 0;
          for (final pkg in pkgs) {
            total += await UsageStatsService.getAppUsageToday(
                packageName: pkg);
          }
          usageMin = total;
        }
      }
    }

    final signal = RiskSignal.now(usageMinutesNow: usageMin);
    return _evaluator.evaluate(terms, signal);
  }
}
