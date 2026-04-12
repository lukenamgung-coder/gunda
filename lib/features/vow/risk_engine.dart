/// Legacy re-export shim.
///
/// The risk engine has been refactored into the domain layer:
///   lib/domain/risk/risk_level.dart    → RiskLevel, RiskSnapshot
///   lib/domain/risk/risk_signal.dart   → RiskSignal
///   lib/domain/risk/risk_evaluator.dart → RiskEvaluator
///   lib/application/use_cases/evaluate_risk.dart → EvaluateRisk
///   lib/features/vow/providers/vow_detail_providers.dart → riskSnapshotProvider
///
/// This file re-exports the key symbols so any existing import of
/// 'risk_engine.dart' continues to compile during the migration.
export '../../application/use_cases/evaluate_risk.dart';
export '../../domain/risk/risk_evaluator.dart';
export '../../domain/risk/risk_level.dart';
export '../../domain/risk/risk_signal.dart';
