import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paginated_products_entity.dart';
import 'product_model.dart';

part 'paginated_products_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedProductsModel extends PaginatedProductsEntity {
  @JsonKey(name: 'items')
  final List<ProductModel> productModels;

  const PaginatedProductsModel({
    required this.productModels,
    required super.pageNumber,
    required super.totalPages,
    required super.totalCount,
    required super.hasPreviousPage,
    required super.hasNextPage,
  }) : super(items: productModels);

  factory PaginatedProductsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedProductsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedProductsModelToJson(this);
}
