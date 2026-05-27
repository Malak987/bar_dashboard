// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  branchId: json['branchId'] as String?,
  branchName: json['branchName'] as String?,
  status: (json['status'] as num).toInt(),
  statusName: json['statusName'] as String,
  couponCode: json['couponCode'] as String?,
  subtotal: (json['subtotal'] as num).toDouble(),
  deliveryFee: (json['deliveryFee'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  note: json['note'] as String?,
  address: json['address'] as String,
  createdDateTime: DateTime.parse(json['createdDateTime'] as String),
  orderItemModels: (json['orderItems'] as List<dynamic>)
      .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  paymentMethodValue: (json['paymentMethodValue'] as num?)?.toInt(),
  isPaid: json['isPaid'] as bool?,
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'branchId': instance.branchId,
      'branchName': instance.branchName,
      'status': instance.status,
      'statusName': instance.statusName,
      'couponCode': instance.couponCode,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'discountAmount': instance.discountAmount,
      'totalAmount': instance.totalAmount,
      'note': instance.note,
      'address': instance.address,
      'createdDateTime': instance.createdDateTime.toIso8601String(),
      'paymentMethodValue': instance.paymentMethodValue,
      'isPaid': instance.isPaid,
      'orderItems': instance.orderItemModels.map((e) => e.toJson()).toList(),
    };
