// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSizeMiniModel _$ProductSizeMiniModelFromJson(
  Map<String, dynamic> json,
) => ProductSizeMiniModel(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  sizeName: json['sizeName'] as String?,
  price: (json['price'] as num).toDouble(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$ProductSizeMiniModelToJson(
  ProductSizeMiniModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'sizeName': instance.sizeName,
  'price': instance.price,
  'imageUrl': instance.imageUrl,
};

ProductFlavorMiniModel _$ProductFlavorMiniModelFromJson(
  Map<String, dynamic> json,
) => ProductFlavorMiniModel(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  imageUrl: json['imageUrl'] as String?,
  extraPrice: (json['extraPrice'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$ProductFlavorMiniModelToJson(
  ProductFlavorMiniModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'imageUrl': instance.imageUrl,
  'extraPrice': instance.extraPrice,
};

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  nameAr: json['nameAr'] as String,
  nameEn: json['nameEn'] as String,
  descriptionAr: json['descriptionAr'] as String,
  descriptionEn: json['descriptionEn'] as String,
  imageUrl: json['imageUrl'] as String?,
  basePrice: (json['basePrice'] as num).toDouble(),
  isFeatured: json['isFeatured'] as bool,
  isBestSeller: json['isBestSeller'] as bool,
  isActive: json['isActive'] as bool,
  isArchived: json['isArchived'] as bool,
  isCustomizable: json['isCustomizable'] as bool? ?? false,
  categoryId: json['categoryId'] as String,
  categoryNameAr: json['categoryNameAr'] as String,
  categoryNameEn: json['categoryNameEn'] as String,
  sizeModels: (json['sizes'] as List<dynamic>)
      .map((e) => ProductSizeMiniModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  flavorModels: (json['flavors'] as List<dynamic>)
      .map((e) => ProductFlavorMiniModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'descriptionAr': instance.descriptionAr,
      'descriptionEn': instance.descriptionEn,
      'imageUrl': instance.imageUrl,
      'basePrice': instance.basePrice,
      'isFeatured': instance.isFeatured,
      'isBestSeller': instance.isBestSeller,
      'isActive': instance.isActive,
      'isArchived': instance.isArchived,
      'isCustomizable': instance.isCustomizable,
      'categoryId': instance.categoryId,
      'categoryNameAr': instance.categoryNameAr,
      'categoryNameEn': instance.categoryNameEn,
      'sizes': instance.sizeModels.map((e) => e.toJson()).toList(),
      'flavors': instance.flavorModels.map((e) => e.toJson()).toList(),
    };
