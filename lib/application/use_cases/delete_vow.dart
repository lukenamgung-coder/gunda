import '../repositories/vow_repository.dart';

/// Permanently delete a vow and all associated records.
///
/// Confirmation dialog is the caller's responsibility.
class DeleteVow {
  final VowRepository _repository;

  const DeleteVow(this._repository);

  Future<void> call(int vowId) => _repository.deleteVow(vowId);
}
