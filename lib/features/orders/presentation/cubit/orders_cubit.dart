import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/paginated_orders_entity.dart';
import '../../domain/usecases/orders_usecases.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetMyOrdersUseCase _getMyOrdersUseCase;
  final GetAllOrdersUseCase _getAllOrdersUseCase;
  final GetOrderByIdUseCase _getOrderByIdUseCase;
  final PlaceOrderUseCase _placeOrderUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;

  bool _isAdminMode = false;

  OrdersCubit(
      this._getMyOrdersUseCase,
      this._getAllOrdersUseCase,
      this._getOrderByIdUseCase,
      this._placeOrderUseCase,
      this._cancelOrderUseCase,
      this._updateOrderStatusUseCase,
      ) : super(const OrdersInitial());

  /// 🔵 Fetch عادي - بيُظهر Loading (للمرة الأولى فقط)
  Future<void> fetchMyOrders() async {
    _isAdminMode = false;
    emit(const OrdersLoading());
    final result = await _getMyOrdersUseCase();
    result.when(
      success: (orders) => emit(OrdersLoaded(orders)),
      failure: (f) => emit(OrdersFailure(f.message)),
    );
  }

  Future<void> fetchAllOrders() async {
    _isAdminMode = true;
    emit(const OrdersLoading());
    final result = await _getAllOrdersUseCase();
    result.when(
      success: (orders) => emit(OrdersLoaded(orders)),
      failure: (f) => emit(OrdersFailure(f.message)),
    );
  }

  // ═══════════════════════════════════════════════════════════
  // 🤫 SILENT REFRESH - بدون Loading state
  // ═══════════════════════════════════════════════════════════

  /// 🤫 Silent Refresh - بيحدّث البيانات بدون ما يعرض Loading
  /// مفيد للـ polling في الخلفية - مفيش رفرفة بصرية
  /// لو الـ fetch فشل، البيانات القديمة تفضل ظاهرة
  Future<void> silentRefreshAllOrders() async {
    _isAdminMode = true;
    final result = await _getAllOrdersUseCase();
    result.when(
      success: (orders) {
        final current = state;
        if (current is OrdersLoaded) {
          // 🎯 مقارنة آمنة بدون cast (نستخدم بيانات بدائية فقط)
          if (_shouldUpdate(current.orders, orders)) {
            emit(OrdersLoaded(orders));
          }
        } else {
          emit(OrdersLoaded(orders));
        }
      },
      failure: (_) {
        // 🔇 نتجاهل الـ error - البيانات القديمة تفضل ظاهرة
      },
    );
  }

  Future<void> silentRefreshMyOrders() async {
    _isAdminMode = false;
    final result = await _getMyOrdersUseCase();
    result.when(
      success: (orders) {
        final current = state;
        if (current is OrdersLoaded) {
          if (_shouldUpdate(current.orders, orders)) {
            emit(OrdersLoaded(orders));
          }
        } else {
          emit(OrdersLoaded(orders));
        }
      },
      failure: (_) {},
    );
  }

  /// 🤫 Silent refresh ذكي - بيختار بين all/my حسب آخر اختيار
  Future<void> silentRefresh() async {
    if (_isAdminMode) {
      await silentRefreshAllOrders();
    } else {
      await silentRefreshMyOrders();
    }
  }

  /// 🎯 مقارنة آمنة بدون أي type cast
  /// بنقارن كل البيانات المهمة عشان نلاقي أي تغيير
  bool _shouldUpdate(
      PaginatedOrdersEntity oldData, PaginatedOrdersEntity newData) {
    // 1. لو العدد اتغير → تحديث فوري
    if (oldData.totalCount != newData.totalCount) return true;
    if (oldData.items.length != newData.items.length) return true;

    // 2. نبني خريطة بالـ IDs لمقارنة أسرع وأدق
    // لو ترتيب الأوردرات اتغير (مثلاً orders بترجع sorted by date)
    // الـ index-based comparison ممكن يبوظ
    final oldMap = <String, dynamic>{};
    for (final item in oldData.items) {
      try {
        oldMap[(item as dynamic).id as String] = item;
      } catch (_) {
        return true;
      }
    }

    for (final newItem in newData.items) {
      try {
        final dynamic newDyn = newItem;
        final String newId = newDyn.id as String;
        final dynamic oldItem = oldMap[newId];

        // أوردر جديد لم يكن موجود
        if (oldItem == null) return true;

        // فيه تغيير في حقول مهمة
        if (oldItem.status != newDyn.status) return true;
        if (oldItem.totalAmount != newDyn.totalAmount) return true;
        if (oldItem.subtotal != newDyn.subtotal) return true;

        // عدد الـ items في الأوردر اتغير
        final oldItemsLen = (oldItem.orderItems as List).length;
        final newItemsLen = (newDyn.orderItems as List).length;
        if (oldItemsLen != newItemsLen) return true;
      } catch (_) {
        // لو في أي مشكلة، نعمل update افتراضياً (آمن)
        return true;
      }
    }
    return false;
  }

  // ═══════════════════════════════════════════════════════════

  Future<void> _refresh() async {
    if (_isAdminMode) {
      await fetchAllOrders();
    } else {
      await fetchMyOrders();
    }
  }

  Future<void> fetchOrderById(String id) async {
    emit(const OrderByIdLoading());
    final result = await _getOrderByIdUseCase(id);
    result.when(
      success: (order) => emit(OrderByIdLoaded(order)),
      failure: (f) => emit(OrderByIdFailure(f.message)),
    );
  }

  Future<void> placeOrder({
    required String address,
    String? note,
    required double deliveryFee,
  }) async {
    emit(const OrderActionLoading());
    final result = await _placeOrderUseCase(
      address: address,
      note: note,
      deliveryFee: deliveryFee,
    );
    result.when(
      success: (msg) => emit(OrderActionSuccess(msg)),
      failure: (f) => emit(OrderActionFailure(f.message)),
    );
  }

  /// ❌ Cancel Order (للعميل نفسه)
  /// يستخدم /api/Orders/CancelOrder - بس بيرفض لو الأدمن هو اللي بيلغي
  Future<void> cancelOrder(String id) async {
    final result = await _cancelOrderUseCase(id);
    result.when(
      success: (msg) {
        emit(OrderActionSuccess(msg));
        silentRefresh();
      },
      failure: (f) => emit(OrderActionFailure(f.message)),
    );
  }

  /// 🛡️ Admin Cancel - الأدمن بيلغي الأوردر باستخدام UpdateOrderStatus
  /// (لأن endpoint /CancelOrder بيرفض غير صاحب الأوردر)
  Future<void> adminCancelOrder(String orderId) async {
    await updateOrderStatus(
      orderId: orderId,
      newStatus: OrderStatus.cancelled,
    );
  }

  Future<void> updateOrderStatus({
    required String orderId,
    required OrderStatus newStatus,
  }) async {
    // 🤫 OrderActionLoading لسه موجود عشان الزر يعرف إنه busy
    // بس بنعمل silent refresh في النهاية بدل refresh كامل
    emit(const OrderActionLoading());
    final result = await _updateOrderStatusUseCase(
      orderId: orderId,
      newStatus: newStatus,
    );
    result.when(
      success: (msg) {
        emit(OrderActionSuccess(msg));
        // ✅ Silent refresh - مفيش rebuild للصفحة كلها
        silentRefresh();
      },
      failure: (f) => emit(OrderActionFailure(f.message)),
    );
  }
}
