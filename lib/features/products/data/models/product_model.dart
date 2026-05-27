import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductSizeMiniModel extends ProductSizeMiniEntity {
  const ProductSizeMiniModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.sizeName,
    required super.price,
    super.imageUrl,
  });

  factory ProductSizeMiniModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeMiniModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSizeMiniModelToJson(this);
}

@JsonSerializable()
class ProductFlavorMiniModel extends ProductFlavorMiniEntity {
  const ProductFlavorMiniModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.imageUrl,
    super.extraPrice = 0,
  });

  factory ProductFlavorMiniModel.fromJson(Map<String, dynamic> json) =>
      _$ProductFlavorMiniModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductFlavorMiniModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ProductModel extends ProductEntity {
  @JsonKey(name: 'sizes')
  final List<ProductSizeMiniModel> sizeModels;

  @JsonKey(name: 'flavors')
  final List<ProductFlavorMiniModel> flavorModels;

  const ProductModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    super.imageUrl,
    required super.basePrice,
    required super.isFeatured,
    required super.isBestSeller,
    required super.isActive,
    required super.isArchived,
    super.isCustomizable = false,
    required super.categoryId,
    required super.categoryNameAr,
    required super.categoryNameEn,
    required this.sizeModels,
    required this.flavorModels,
  }) : super(sizes: sizeModels, flavors: flavorModels);

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
