import '../../domain/models/contract_vow.dart';
import '../../domain/models/domain_violation.dart';
import '../../shared/models/enums.dart';

/// Port — defines what the vow feature needs from persistence.
///
/// The application layer depends on this abstraction.
/// The infrastructure layer provides the Drift implementation.
/// Swap the implementation (e.g. for a remote API) without
/// touching any use-case or widget code.
abstract interface class VowRepository {
  /// Stream of all contracts for a user, newest first.
  Stream<List<ContractVow>> watchAllVows(int userId);

  /// Stream of a single contract. Emits null if not found.
  Stream<ContractVow?> watchVow(int id);

  /// Stream of all violations for a vow, newest first.
  Stream<List<DomainViolation>> watchViolations(int vowId);

  /// Permanently delete a vow and all related records.
  Future<void> deleteVow(int id);

  /// Transition the vow lifecycle state.
  Future<void> updateStatus(int id, VowStatus status);

  /// Update the KakaoPay payment status for a violation.
  Future<void> updatePaymentStatus(
      int violationId, PaymentStatus status);
}
