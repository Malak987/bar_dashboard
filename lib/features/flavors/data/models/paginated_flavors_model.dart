import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/paginated_flavors_entity.dart';
import 'flavor_model.dart';

part 'paginated_flavors_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PaginatedFlavorsModel extends PaginatedFlavorsEntity {
  @JsonKey(name: 'items')
  final List<FlavorModel> flavorModels;

  const PaginatedFlavorsModel({
    required this.flavorModels,
    required super.pageNumber,
    required super.totalPages,
    required super.totalCount,
    required super.hasPreviousPage,
    required super.hasNextPage,
  }) : super(items: flavorModels);

  factory PaginatedFlavorsModel.fromJson(Map<String, dynamic> json) =>
      _$PaginatedFlavorsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedFlavorsModelToJson(this);
}
