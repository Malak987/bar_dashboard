import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'order_status.dart';
import 'payment_method.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? branchId;
  final String? branchName;
  final int status;
  final String statusName;
  final String? couponCode;
  final double subtotal;
  final double deliveryFee;
  final double discountAmount;
  final double totalAmount;
  final String? note;
  final String address;
  final DateTime createdDateTime;
  final List<OrderItemEntity> orderItems;

  /// 🆕 طريقة الدفع (لو الـ Backend بيرجعها)
  /// لو null → بنعرض "غير محدد"
  final int? paymentMethodValue;

  /// 🆕 هل تم الدفع؟ (لو الـ Backend بيرجعها)
  final bool? isPaid;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.branchId,
    this.branchName,
    required this.status,
    required this.statusName,
    this.couponCode,
    required this.subtotal,
    required this.deliveryFee,
    this.discountAmount = 0,
    required this.totalAmount,
    this.note,
    required this.address,
    required this.createdDateTime,
    required this.orderItems,
    this.paymentMethodValue,
    this.isPaid,
  });

  OrderStatus get orderStatus => OrderStatus.fromValue(status);
  PaymentMethod get paymentMethod =>
      PaymentMethod.fromValue(paymentMethodValue);

  int get itemsCount => orderItems.fold(0, (sum, i) => sum + i.quantity);

  @override
  List<Object?> get props => [
    id,
    userId,
    userName,
    branchId,
    branchName,
    status,
    statusName,
    couponCode,
    subtotal,
    deliveryFee,
    discountAmount,
    totalAmount,
    note,
    address,
    createdDateTime,
    orderItems,
    paymentMethodValue,
    isPaid,
  ];
}
