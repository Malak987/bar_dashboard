import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';
import '../repositories/accounts_repository.dart';

class AdminLoginUseCase {
  final AccountsRepository _repository;
  AdminLoginUseCase(this._repository);

  Future<Result<AuthEntity>> call({
    required String email,
    required String password,
  }) {
    return _repository.adminLogin(email: email, password: password);
  }
}
