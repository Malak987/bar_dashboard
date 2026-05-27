import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_constants.dart';
import 'auth_interceptor.dart';
import '../storage/auth_local_storage.dart';

class DioFactory {
  static Dio create(AuthLocalStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    dio.interceptors.add(AuthInterceptor(storage));

    // ✅ Custom logger يشتغل على Web و Mobile
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          developer.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━',
              name: 'HTTP');
          developer.log('🔵 ${options.method} ${options.uri}', name: 'HTTP');
          if (options.data is FormData) {
            final fd = options.data as FormData;
            developer.log('📦 FormData fields:', name: 'HTTP');
            for (final field in fd.fields) {
              developer.log('   ${field.key} = ${field.value}',
                  name: 'HTTP');
            }
            for (final file in fd.files) {
              developer.log(
                  '   📎 ${file.key} = file (${file.value.filename}, ${file.value.length} bytes)',
                  name: 'HTTP');
            }
          } else if (options.data != null) {
            developer.log('📦 Body: ${options.data}', name: 'HTTP');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          developer.log(
              '🟢 ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.uri}',
              name: 'HTTP');
          developer.log('📥 Response: ${response.data}', name: 'HTTP');
          handler.next(response);
        },
        onError: (e, handler) {
          developer.log(
              '🔴 ERROR ${e.response?.statusCode ?? "?"} ${e.requestOptions.method} ${e.requestOptions.uri}',
              name: 'HTTP');
          developer.log('📥 Error data: ${e.response?.data}', name: 'HTTP');
          developer.log('📝 Error message: ${e.message}', name: 'HTTP');
          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

    return dio;
  }
}
