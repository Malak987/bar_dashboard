import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/flavor_entity.dart';

part 'flavor_model.g.dart';

@JsonSerializable()
class FlavorModel extends FlavorEntity {
  const FlavorModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    required super.descriptionAr,
    required super.descriptionEn,
    super.imageUrl,
    required super.isAvailable,
    required super.isArchived,
  });

  factory FlavorModel.fromJson(Map<String, dynamic> json) =>
      _$FlavorModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlavorModelToJson(this);
}
