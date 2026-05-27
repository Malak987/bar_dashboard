// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_cart_item_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCartItemRequestModel _$UpdateCartItemRequestModelFromJson(
  Map<String, dynamic> json,
) => UpdateCartItemRequestModel(
  cartItemId: json['cartItemId'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$UpdateCartItemRequestModelToJson(
  UpdateCartItemRequestModel instance,
) => <String, dynamic>{
  'cartItemId': instance.cartItemId,
  'quantity': instance.quantity,
};
