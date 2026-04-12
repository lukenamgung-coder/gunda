import '../../shared/models/enums.dart';
import '../repositories/vow_repository.dart';

/// Transition a vow to the paused state.
///
/// Extracted as a use case so the pause intent is
/// a named concept in the application layer, not an
/// anonymous `db.updateVowStatus(id, 'paused')` call
/// scattered across widgets.
class PauseVow {
  final VowRepository _repository;

  const PauseVow(this._repository);

  Future<void> call(int vowId) =>
      _repository.updateStatus(vowId, VowStatus.paused);
}
