import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/paginated_users_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/usecases/update_user_archive_status_usecase.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;
  final UpdateUserArchiveStatusUseCase _updateArchiveStatusUseCase;

  UsersCubit(
    this._getAllUsersUseCase,
    this._getUserByIdUseCase,
    this._updateArchiveStatusUseCase,
  ) : super(const UsersInitial());

  Future<void> fetchAllUsers() async {
    emit(const UsersLoading());
    final result = await _getAllUsersUseCase();
    result.when(
      success: (users) => emit(UsersLoaded(users)),
      failure: (f) => emit(UsersFailure(f.message)),
    );
  }

  Future<void> silentRefreshAllUsers() async {
    final result = await _getAllUsersUseCase();
    result.when(
      success: (users) {
        final current = state;
        if (current is UsersLoaded) {
          if (_usersChanged(current.users.items, users.items) ||
              current.users.totalCount != users.totalCount) {
            emit(UsersLoaded(users));
          }
        } else {
          emit(UsersLoaded(users));
        }
      },
      failure: (_) {},
    );
  }

  bool _usersChanged(List oldList, List newList) {
    if (oldList.length != newList.length) return true;
    final oldMap = <String, dynamic>{};
    for (final item in oldList) {
      try {
        oldMap[(item as dynamic).id as String] = item;
      } catch (_) {
        return true;
      }
    }

    for (final newItem in newList) {
      try {
        final dynamic n = newItem;
        final dynamic o = oldMap[n.id as String];
        if (o == null) return true;
        if (o.isArchived != n.isArchived) return true;
        if (o.name != n.name) return true;
        if (o.phoneNumber != n.phoneNumber) return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchUserById(String id) async {
    emit(const UserByIdLoading());
    final result = await _getUserByIdUseCase(id);
    result.when(
      success: (user) => emit(UserByIdLoaded(user)),
      failure: (f) => emit(UserByIdFailure(f.message)),
    );
  }

  /// 🚫 حظر العميل مع سبب
  Future<void> blockUser({
    required String userId,
    required String reason,
  }) async {
    emit(const UserActionLoading());
    final result = await _updateArchiveStatusUseCase(
      userId: userId,
      isArchived: true,
      reason: reason,
    );
    result.when(
      success: (msg) {
        emit(UserActionSuccess(msg));
        silentRefreshAllUsers();
      },
      failure: (f) => emit(UserActionFailure(f.message)),
    );
  }

  /// 🔓 فك حظر العميل
  Future<void> unblockUser(String userId) async {
    emit(const UserActionLoading());
    final result = await _updateArchiveStatusUseCase(
      userId: userId,
      isArchived: false,
      reason: null,
    );
    result.when(
      success: (msg) {
        emit(UserActionSuccess(msg));
        silentRefreshAllUsers();
      },
      failure: (f) => emit(UserActionFailure(f.message)),
    );
  }
}
