// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemFlavorModel _$OrderItemFlavorModelFromJson(
  Map<String, dynamic> json,
) => OrderItemFlavorModel(
  flavorId: json['flavorId'] as String,
  flavorNameAr: json['flavorNameAr'] as String?,
  flavorNameEn: json['flavorNameEn'] as String?,
);

Map<String, dynamic> _$OrderItemFlavorModelToJson(
  OrderItemFlavorModel instance,
) => <String, dynamic>{
  'flavorId': instance.flavorId,
  'flavorNameAr': instance.flavorNameAr,
  'flavorNameEn': instance.flavorNameEn,
};

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) =>
    OrderItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String?,
      productNameAr: json['productNameAr'] as String?,
      productNameEn: json['productNameEn'] as String?,
      productImageUrl: json['productImageUrl'] as String?,
      sizeId: json['sizeId'] as String?,
      sizeName: json['sizeName'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      note: json['note'] as String?,
      flavorModels: (json['flavors'] as List<dynamic>)
          .map((e) => OrderItemFlavorModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderItemModelToJson(OrderItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productNameAr': instance.productNameAr,
      'productNameEn': instance.productNameEn,
      'productImageUrl': instance.productImageUrl,
      'sizeId': instance.sizeId,
      'sizeName': instance.sizeName,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'totalPrice': instance.totalPrice,
      'note': instance.note,
      'flavors': instance.flavorModels.map((e) => e.toJson()).toList(),
    };
