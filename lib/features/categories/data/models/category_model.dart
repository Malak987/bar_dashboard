import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category_entity.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    super.imageUrl,
    required super.isArchived,
    required super.productsCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
