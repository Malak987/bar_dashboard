// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_to_cart_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddToCartRequestModel _$AddToCartRequestModelFromJson(
  Map<String, dynamic> json,
) => AddToCartRequestModel(
  productId: json['productId'] as String,
  productSizeId: json['productSizeId'] as String,
  flavorIds: (json['flavorIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  quantity: (json['quantity'] as num).toInt(),
  note: json['note'] as String?,
);

Map<String, dynamic> _$AddToCartRequestModelToJson(
  AddToCartRequestModel instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'productSizeId': instance.productSizeId,
  'flavorIds': instance.flavorIds,
  'quantity': instance.quantity,
  'note': instance.note,
};
