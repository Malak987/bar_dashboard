import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';
import 'order_item_model.dart';

part 'order_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderModel extends OrderEntity {
  @JsonKey(name: 'orderItems')
  final List<OrderItemModel> orderItemModels;

  const OrderModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.branchId,
    super.branchName,
    required super.status,
    required super.statusName,
    super.couponCode,
    required super.subtotal,
    required super.deliveryFee,
    super.discountAmount = 0,
    required super.totalAmount,
    super.note,
    required super.address,
    required super.createdDateTime,
    required this.orderItemModels,
    super.paymentMethodValue,
    super.isPaid,
  }) : super(orderItems: orderItemModels);

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
