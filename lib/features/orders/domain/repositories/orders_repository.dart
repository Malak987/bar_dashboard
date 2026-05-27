import '../../../../core/utils/result.dart';
import '../entities/order_entity.dart';
import '../entities/order_status.dart';
import '../entities/paginated_orders_entity.dart';

abstract class OrdersRepository {
  Future<Result<PaginatedOrdersEntity>> getMyOrders();
  Future<Result<PaginatedOrdersEntity>> getAllOrders();
  Future<Result<OrderEntity>> getOrderById(String id);

  Future<Result<String>> placeOrder({
    required String address,
    String? note,
    required double deliveryFee,
  });

  Future<Result<String>> cancelOrder(String id);

  Future<Result<String>> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  });
}
