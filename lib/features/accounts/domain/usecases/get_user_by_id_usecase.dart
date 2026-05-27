import '../../../../core/utils/result.dart';
import '../entities/user_entity.dart';
import '../repositories/accounts_repository.dart';

class GetUserByIdUseCase {
  final AccountsRepository _repository;
  GetUserByIdUseCase(this._repository);

  Future<Result<UserEntity>> call(String id) => _repository.getUserById(id);
}
