import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/paginated_orders_entity.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_web_service.dart';
import '../models/place_order_request_model.dart';
import '../models/update_order_status_request_model.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersWebService _webService;

  OrdersRepositoryImpl(this._webService);

  @override
  Future<Result<PaginatedOrdersEntity>> getMyOrders() async {
    try {
      final response = await _webService.getMyOrders();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تحميل الطلبات'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<PaginatedOrdersEntity>> getAllOrders() async {
    try {
      final response = await _webService.getAllOrders();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تحميل الطلبات'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<OrderEntity>> getOrderById(String id) async {
    try {
      final response = await _webService.getOrderById(id);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'الطلب غير موجود'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> placeOrder({
    required String address,
    String? note,
    required double deliveryFee,
  }) async {
    try {
      final response = await _webService.placeOrder(
        PlaceOrderRequestModel(
          address: address,
          note: note,
          deliveryFee: deliveryFee,
        ),
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ??
              response.message ??
              'تم إنشاء الطلب بنجاح',
        );
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل إنشاء الطلب'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> cancelOrder(String id) async {
    try {
      final response = await _webService.cancelOrder(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم إلغاء الطلب');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل إلغاء الطلب'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    try {
      final response = await _webService.updateOrderStatus(
        UpdateOrderStatusRequestModel(
          orderId: orderId,
          newStatus: newStatus.value,
        ),
      );
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم تحديث حالة الطلب');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تحديث الحالة'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
