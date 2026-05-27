import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/paginated_users_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_all_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetAllUsersUseCase _getAllUsersUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;

  UsersCubit(this._getAllUsersUseCase, this._getUserByIdUseCase)
      : super(const UsersInitial());

  Future<void> fetchAllUsers() async {
    emit(const UsersLoading());
    final result = await _getAllUsersUseCase();
    result.when(
      success: (users) => emit(UsersLoaded(users)),
      failure: (f) => emit(UsersFailure(f.message)),
    );
  }

  Future<void> fetchUserById(String id) async {
    emit(const UserByIdLoading());
    final result = await _getUserByIdUseCase(id);
    result.when(
      success: (user) => emit(UserByIdLoaded(user)),
      failure: (f) => emit(UserByIdFailure(f.message)),
    );
  }
}
