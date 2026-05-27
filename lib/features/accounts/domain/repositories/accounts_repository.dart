import '../../../../core/utils/result.dart';
import '../entities/auth_entity.dart';
import '../entities/paginated_users_entity.dart';
import '../entities/user_entity.dart';

abstract class AccountsRepository {
  Future<Result<String>> registerAdmin({
    required String email,
    required String password,
  });

  Future<Result<AuthEntity>> adminLogin({
    required String email,
    required String password,
  });

  Future<Result<PaginatedUsersEntity>> getAllUsers();

  Future<Result<UserEntity>> getUserById(String id);

  /// حظر / فك حظر العميل
  Future<Result<String>> updateUserArchiveStatus({
    required String userId,
    required bool isArchived,
    String? reason,
  });
}
