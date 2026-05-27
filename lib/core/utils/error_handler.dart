import 'package:dio/dio.dart';
import '../error/failure.dart';

class ErrorHandler {
  /// بيحول DioException أو أي error لـ Failure مناسبة
  static Failure handle(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    return UnknownFailure(error.toString());
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('انتهت مهلة الاتصال');

      case DioExceptionType.connectionError:
        return const NetworkFailure('لا يوجد اتصال بالإنترنت');

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return const UnknownFailure('تم إلغاء الطلب');

      default:
        return UnknownFailure(error.message ?? 'حدث خطأ غير متوقع');
    }
  }

  static Failure _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    String message = 'حدث خطأ في الخادم';
    if (data is Map && data['message'] != null) {
      message = data['message'].toString();
    }

    if (statusCode == 401) {
      return UnauthorizedFailure(message);
    }
    return ServerFailure(message, statusCode: statusCode);
  }
}
