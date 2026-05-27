import '../../../../core/utils/result.dart';
import '../entities/paginated_users_entity.dart';
import '../repositories/accounts_repository.dart';

class GetAllUsersUseCase {
  final AccountsRepository _repository;
  GetAllUsersUseCase(this._repository);

  Future<Result<PaginatedUsersEntity>> call() => _repository.getAllUsers();
}
