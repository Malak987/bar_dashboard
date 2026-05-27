part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

// Login states
class LoginLoading extends AuthState {
  const LoginLoading();
}

class LoginSuccess extends AuthState {
  final AuthEntity auth;
  const LoginSuccess(this.auth);
  @override
  List<Object?> get props => [auth];
}

class LoginFailure extends AuthState {
  final String message;
  const LoginFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Register states
class RegisterLoading extends AuthState {
  const RegisterLoading();
}

class RegisterSuccess extends AuthState {
  final String message;
  const RegisterSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class RegisterFailure extends AuthState {
  final String message;
  const RegisterFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class LoggedOut extends AuthState {
  const LoggedOut();
}
