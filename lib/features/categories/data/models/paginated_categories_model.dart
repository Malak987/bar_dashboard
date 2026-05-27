import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paginated_categories_entity.dart';
import 'category_model.dart';

part 'paginated_categories_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedCategoriesModel extends PaginatedCategoriesEntity {
  @JsonKey(name: 'items')
  final List<CategoryModel> categoryModels;

  const PaginatedCategoriesModel({
    required this.categoryModels,
    required super.pageNumber,
    required super.totalPages,
    required super.totalCount,
    required super.hasPreviousPage,
    required super.hasNextPage,
  }) : super(items: categoryModels);

  factory PaginatedCategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedCategoriesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedCategoriesModelToJson(this);
}
