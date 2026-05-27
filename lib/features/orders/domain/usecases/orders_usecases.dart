import '../../../../core/utils/result.dart';
import '../entities/order_entity.dart';
import '../entities/order_status.dart';
import '../entities/paginated_orders_entity.dart';
import '../repositories/orders_repository.dart';

class GetMyOrdersUseCase {
  final OrdersRepository _repository;
  GetMyOrdersUseCase(this._repository);
  Future<Result<PaginatedOrdersEntity>> call() => _repository.getMyOrders();
}

class GetAllOrdersUseCase {
  final OrdersRepository _repository;
  GetAllOrdersUseCase(this._repository);
  Future<Result<PaginatedOrdersEntity>> call() => _repository.getAllOrders();
}

class GetOrderByIdUseCase {
  final OrdersRepository _repository;
  GetOrderByIdUseCase(this._repository);
  Future<Result<OrderEntity>> call(String id) => _repository.getOrderById(id);
}

class PlaceOrderUseCase {
  final OrdersRepository _repository;
  PlaceOrderUseCase(this._repository);
  Future<Result<String>> call({
    required String address,
    String? note,
    required double deliveryFee,
  }) =>
      _repository.placeOrder(
        address: address,
        note: note,
        deliveryFee: deliveryFee,
      );
}

class CancelOrderUseCase {
  final OrdersRepository _repository;
  CancelOrderUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.cancelOrder(id);
}

class UpdateOrderStatusUseCase {
  final OrdersRepository _repository;
  UpdateOrderStatusUseCase(this._repository);
  Future<Result<String>> call({
    required String orderId,
    required OrderStatus newStatus,
  }) =>
      _repository.updateOrderStatus(orderId: orderId, newStatus: newStatus);
}
