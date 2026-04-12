import '../../domain/models/contract_vow.dart';
import '../repositories/vow_repository.dart';

/// Observe a single vow as a reactive stream.
///
/// Returns null when the vow doesn't exist (deleted / not found).
class GetVowDetail {
  final VowRepository _repository;

  const GetVowDetail(this._repository);

  Stream<ContractVow?> call(int vowId) =>
      _repository.watchVow(vowId);
}
