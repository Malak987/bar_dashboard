import '../../../../core/utils/result.dart';
import '../repositories/accounts_repository.dart';

class RegisterAdminUseCase {
  final AccountsRepository _repository;
  RegisterAdminUseCase(this._repository);

  Future<Result<String>> call({
    required String email,
    required String password,
  }) {
    return _repository.registerAdmin(email: email, password: password);
  }
}
