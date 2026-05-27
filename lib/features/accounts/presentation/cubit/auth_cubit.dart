import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/storage/auth_local_storage.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/admin_login_usecase.dart';
import '../../domain/usecases/register_admin_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AdminLoginUseCase _loginUseCase;
  final RegisterAdminUseCase _registerUseCase;
  final AuthLocalStorage _storage;

  AuthCubit(this._loginUseCase, this._registerUseCase, this._storage)
      : super(const AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());
    final result = await _loginUseCase(email: email, password: password);
    result.when(
      success: (auth) => emit(LoginSuccess(auth)),
      failure: (f) => emit(LoginFailure(f.message)),
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(const RegisterLoading());
    final result = await _registerUseCase(email: email, password: password);
    result.when(
      success: (msg) => emit(RegisterSuccess(msg)),
      failure: (f) => emit(RegisterFailure(f.message)),
    );
  }

  Future<void> logout() async {
    await _storage.clear();
    emit(const LoggedOut());
  }
}
