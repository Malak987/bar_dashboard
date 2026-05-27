part of 'users_cubit.dart';

sealed class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class UsersLoading extends UsersState {
  const UsersLoading();
}

class UsersLoaded extends UsersState {
  final PaginatedUsersEntity users;
  const UsersLoaded(this.users);
  @override
  List<Object?> get props => [users];
}

class UsersFailure extends UsersState {
  final String message;
  const UsersFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// User by Id states
class UserByIdLoading extends UsersState {
  const UserByIdLoading();
}

class UserByIdLoaded extends UsersState {
  final UserEntity user;
  const UserByIdLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

class UserByIdFailure extends UsersState {
  final String message;
  const UserByIdFailure(this.message);
  @override
  List<Object?> get props => [message];
}
