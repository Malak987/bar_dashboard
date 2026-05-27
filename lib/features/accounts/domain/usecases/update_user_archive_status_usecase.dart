import '../../../../core/utils/result.dart';
import '../repositories/accounts_repository.dart';

class UpdateUserArchiveStatusUseCase {
  final AccountsRepository _repository;
  UpdateUserArchiveStatusUseCase(this._repository);

  Future<Result<String>> call({
    required String userId,
    required bool isArchived,
    String? reason,
  }) =>
      _repository.updateUserArchiveStatus(
        userId: userId,
        isArchived: isArchived,
        reason: reason,
      );
}
