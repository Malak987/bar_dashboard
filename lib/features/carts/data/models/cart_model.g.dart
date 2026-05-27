// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as String?,
      productId: json['productId'] as String?,
      productName: json['productName'] as String?,
      productSizeId: json['productSizeId'] as String?,
      flavorIds: (json['flavorIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num?)?.toDouble(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'productSizeId': instance.productSizeId,
      'flavorIds': instance.flavorIds,
      'quantity': instance.quantity,
      'price': instance.price,
      'note': instance.note,
    };

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
  id: json['id'] as String,
  userId: json['userId'] as String,
  cartItemModels: (json['cartItems'] as List<dynamic>)
      .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPrice: (json['totalPrice'] as num).toDouble(),
);

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'totalPrice': instance.totalPrice,
  'cartItems': instance.cartItemModels.map((e) => e.toJson()).toList(),
};
