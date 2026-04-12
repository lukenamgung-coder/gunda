import '../../shared/models/enums.dart';
import '../repositories/vow_repository.dart';

/// Transition a vow from paused back to the active state.
class ResumeVow {
  final VowRepository _repository;

  const ResumeVow(this._repository);

  Future<void> call(int vowId) =>
      _repository.updateStatus(vowId, VowStatus.active);
}
