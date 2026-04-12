import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/repositories/vow_repository.dart';
import '../../../application/use_cases/compute_behavioral_insight.dart';
import '../../../application/use_cases/evaluate_risk.dart';
import '../../../application/use_cases/get_vow_detail.dart';
import '../../../application/use_cases/observe_violations.dart';
import '../../../application/use_cases/delete_vow.dart';
import '../../../application/use_cases/pause_vow.dart';
import '../../../application/use_cases/resume_vow.dart';
import '../../../core/providers/database_provider.dart';
import '../../../domain/models/behavioral_insight.dart';
import '../../../domain/models/contract_terms.dart';
import '../../../domain/models/contract_vow.dart';
import '../../../domain/models/date_range.dart';
import '../../../domain/models/domain_violation.dart';
import '../../../domain/risk/risk_evaluator.dart';
import '../../../domain/risk/risk_level.dart';
import '../../../infrastructure/drift/drift_vow_repository.dart';

// ── Repository ────────────────────────────────────────────

/// Wires the Drift adapter to the abstract repository port.
final vowRepositoryProvider = Provider<VowRepository>((ref) {
  return DriftVowRepository(ref.watch(appDatabaseProvider));
});

// ── Use-case providers ────────────────────────────────────

final _getVowDetailProvider = Provider((ref) {
  return GetVowDetail(ref.watch(vowRepositoryProvider));
});

final _observeViolationsProvider = Provider((ref) {
  return ObserveViolations(ref.watch(vowRepositoryProvider));
});

final pauseVowProvider = Provider((ref) {
  return PauseVow(ref.watch(vowRepositoryProvider));
});

final deleteVowProvider = Provider((ref) {
  return DeleteVow(ref.watch(vowRepositoryProvider));
});

final resumeVowProvider = Provider((ref) {
  return ResumeVow(ref.watch(vowRepositoryProvider));
});

// ── Data providers ────────────────────────────────────────

/// Reactive stream of the contract. Emits null if not found.
final contractVowProvider =
    StreamProvider.family<ContractVow?, int>((ref, vowId) {
  return ref.watch(_getVowDetailProvider)(vowId);
});

/// Reactive stream of violations, newest first.
final domainViolationsProvider =
    StreamProvider.family<List<DomainViolation>, int>((ref, vowId) {
  return ref.watch(_observeViolationsProvider)(vowId);
});

/// Risk snapshot — refetched whenever ContractTerms change, and every 30 s.
final riskSnapshotProvider =
    StreamProvider.family<RiskSnapshot, ContractTerms>((ref, terms) async* {
  while (true) {
    yield await const EvaluateRisk(RiskEvaluator()).call(terms);
    await Future.delayed(const Duration(seconds: 30));
  }
});

// ── Behavioral insight ────────────────────────────────────

/// Streak + trend — derived synchronously from violations + period.
///
/// Family key uses a record type so Riverpod can cache per (vowId, period).
typedef _InsightArgs = ({int vowId, ContractDateRange period});

/// Updates payment status for a violation (called on KakaoPay deeplink callback).
final updatePaymentStatusProvider = Provider((ref) {
  return ref.watch(vowRepositoryProvider).updatePaymentStatus;
});

final behavioralInsightProvider =
    Provider.family<AsyncValue<BehavioralInsight>, _InsightArgs>(
        (ref, args) {
  final violationsAsync = ref.watch(domainViolationsProvider(args.vowId));
  return violationsAsync.whenData(
    (violations) => const ComputeBehavioralInsight()(
      violations,
      args.period,
    ),
  );
});
