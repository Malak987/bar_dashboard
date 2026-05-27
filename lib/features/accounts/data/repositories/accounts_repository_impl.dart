import '../../../../core/error/failure.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/paginated_users_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/accounts_repository.dart';
import '../datasources/accounts_web_service.dart';
import '../models/auth_request_model.dart';

class AccountsRepositoryImpl implements AccountsRepository {
  final AccountsWebService _webService;
  final AuthLocalStorage _storage;

  AccountsRepositoryImpl(this._webService, this._storage);

  @override
  Future<Result<String>> registerAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _webService.registerAdmin(
        AuthRequestModel(email: email, password: password),
      );
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم التسجيل بنجاح');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل التسجيل'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<AuthEntity>> adminLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _webService.adminLogin(
        AuthRequestModel(email: email, password: password),
      );
      if (response.isSucceeded && response.data != null) {
        final auth = response.data!;
        // حفظ التوكين والبيانات
        await _storage.saveToken(auth.token);
        await _storage.saveUserId(auth.userId);
        await _storage.saveUserName(auth.userName);
        return Success(auth);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تسجيل الدخول'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<PaginatedUsersEntity>> getAllUsers() async {
    try {
      final response = await _webService.getAllUsers();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل جلب المستخدمين'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<UserEntity>> getUserById(String id) async {
    try {
      final response = await _webService.getUserById(id);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'المستخدم غير موجود'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
