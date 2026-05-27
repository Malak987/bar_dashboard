import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paginated_orders_entity.dart';
import 'order_model.dart';

part 'paginated_orders_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedOrdersModel extends PaginatedOrdersEntity {
  @JsonKey(name: 'items')
  final List<OrderModel> orderModels;

  const PaginatedOrdersModel({
    required this.orderModels,
    required super.pageNumber,
    required super.totalPages,
    required super.totalCount,
    required super.hasPreviousPage,
    required super.hasNextPage,
  }) : super(items: orderModels);

  factory PaginatedOrdersModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedOrdersModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedOrdersModelToJson(this);
}
