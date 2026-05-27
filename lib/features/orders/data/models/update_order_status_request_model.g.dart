// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_order_status_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOrderStatusRequestModel _$UpdateOrderStatusRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateOrderStatusRequestModel(
  orderId: json['orderId'] as String,
  newStatus: (json['newStatus'] as num).toInt(),
);

Map<String, dynamic> _$UpdateOrderStatusRequestModelToJson(
  UpdateOrderStatusRequestModel instance,
) => <String, dynamic>{
  'orderId': instance.orderId,
  'newStatus': instance.newStatus,
};
