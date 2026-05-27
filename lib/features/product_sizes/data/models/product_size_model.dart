import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_size_entity.dart';

part 'product_size_model.g.dart';

@JsonSerializable()
class ProductSizeModel extends ProductSizeEntity {
  const ProductSizeModel({
    required super.id,
    required super.productId,
    required super.nameAr,
    required super.nameEn,
    super.sizeName,
    super.descriptionAr,
    super.descriptionEn,
    required super.price,
    super.imageUrl,
    required super.isAvailable,
    required super.isArchived,
    super.radius,
    super.height,
    super.serves,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSizeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSizeModelToJson(this);
}
