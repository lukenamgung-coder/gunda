import '../../domain/models/domain_violation.dart';
import '../repositories/vow_repository.dart';

/// Observe the violation timeline for a vow.
class ObserveViolations {
  final VowRepository _repository;

  const ObserveViolations(this._repository);

  Stream<List<DomainViolation>> call(int vowId) =>
      _repository.watchViolations(vowId);
}
