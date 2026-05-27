// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_size_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSizeModel _$ProductSizeModelFromJson(Map<String, dynamic> json) =>
    ProductSizeModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      sizeName: json['sizeName'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      isAvailable: json['isAvailable'] as bool,
      isArchived: json['isArchived'] as bool,
      radius: (json['radius'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      serves: json['serves'] as String?,
    );

Map<String, dynamic> _$ProductSizeModelToJson(ProductSizeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'sizeName': instance.sizeName,
      'descriptionAr': instance.descriptionAr,
      'descriptionEn': instance.descriptionEn,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'isAvailable': instance.isAvailable,
      'isArchived': instance.isArchived,
      'radius': instance.radius,
      'height': instance.height,
      'serves': instance.serves,
    };
