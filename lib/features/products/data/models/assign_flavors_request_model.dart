import 'package:json_annotation/json_annotation.dart';

part 'assign_flavors_request_model.g.dart';

@JsonSerializable()
class FlavorWithExtraPriceModel {
  final String flavorId;
  final double extraPrice;

  FlavorWithExtraPriceModel({
    required this.flavorId,
    required this.extraPrice,
  });

  Map<String, dynamic> toJson() =>
      _$FlavorWithExtraPriceModelToJson(this);

  factory FlavorWithExtraPriceModel.fromJson(Map<String, dynamic> json) =>
      _$FlavorWithExtraPriceModelFromJson(json);
}

@JsonSerializable(explicitToJson: true)
class AssignFlavorsRequestModel {
  final String productId;
  final List<FlavorWithExtraPriceModel> flavors;

  AssignFlavorsRequestModel({
    required this.productId,
    required this.flavors,
  });

  Map<String, dynamic> toJson() => _$AssignFlavorsRequestModelToJson(this);

  factory AssignFlavorsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AssignFlavorsRequestModelFromJson(json);
}
