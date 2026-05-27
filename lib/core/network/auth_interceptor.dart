import 'package:dio/dio.dart';
import '../storage/auth_local_storage.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // لو 401 ممكن نمسح التوكين هنا
    if (err.response?.statusCode == 401) {
      _storage.clear();
    }
    handler.next(err);
  }
}
