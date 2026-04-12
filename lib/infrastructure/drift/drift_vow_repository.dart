import '../../application/repositories/vow_repository.dart';
import '../../core/database/app_database.dart';
import '../../domain/models/contract_terms.dart';
import '../../domain/models/contract_vow.dart';
import '../../domain/models/date_range.dart';
import '../../domain/models/domain_violation.dart';
import '../../domain/models/enforcer.dart';
import '../../domain/models/money.dart';
import '../../domain/models/vow_stats.dart';
import '../../shared/models/enums.dart';
import '../../shared/models/pledge_condition.dart';

/// Drift implementation of [VowRepository].
///
/// Maps DB rows → domain objects. UI and use-cases never
/// see Drift-generated types; they only see ContractVow,
/// DomainViolation, etc.
class DriftVowRepository implements VowRepository {
  final AppDatabase _db;

  const DriftVowRepository(this._db);

  // ── VowRepository ─────────────────────────────────────

  @override
  Stream<List<ContractVow>> watchAllVows(int userId) {
    return _db
        .watchVows(userId)
        .map((rows) => rows.map(_mapVow).toList());
  }

  @override
  Stream<ContractVow?> watchVow(int id) {
    return _db
        .watchVowById(id)
        .map((row) => row == null ? null : _mapVow(row));
  }

  @override
  Stream<List<DomainViolation>> watchViolations(int vowId) {
    return _db
        .watchViolations(vowId)
        .map((rows) => rows.map(_mapViolation).toList());
  }

  @override
  Future<void> deleteVow(int id) => _db.deleteVow(id);

  @override
  Future<void> updateStatus(int id, VowStatus status) {
    return _db.updateVowStatus(id, status.name);
  }

  @override
  Future<void> updatePaymentStatus(
      int violationId, PaymentStatus status) {
    return _db.updateViolationPayment(
      violationId: violationId,
      status: status.name,
    );
  }

  // ── Mappers ───────────────────────────────────────────

  ContractVow _mapVow(Vow row) {
    final condition =
        PledgeCondition.fromJsonString(row.conditionJson);

    return ContractVow(
      id: row.id,
      title: row.title,
      status: VowStatus.values.byName(row.status),
      terms: ContractTerms(
        condition: condition,
        period: ContractDateRange(
          start: row.startDate,
          end: row.endDate,
        ),
        penalty: Money(row.penaltyAmount),
      ),
      enforcer: Enforcer.fromStorageString(row.penaltyRecipient),
      stats: VowStats(
        totalVerifications: row.totalVerifications,
        passedVerifications: row.passedVerifications,
        totalFinesPaid: Money(row.totalFinesPaid),
      ),
    );
  }

  DomainViolation _mapViolation(Violation row) {
    return DomainViolation(
      id: row.id,
      violatedAt: row.violatedAt,
      penalty: Money(row.penaltyAmount),
      paymentStatus:
          PaymentStatus.values.byName(row.paymentStatus),
    );
  }
}
