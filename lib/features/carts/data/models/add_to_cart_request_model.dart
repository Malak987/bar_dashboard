import 'package:json_annotation/json_annotation.dart';

part 'add_to_cart_request_model.g.dart';

@JsonSerializable()
class AddToCartRequestModel {
  final String productId;
  final String productSizeId;
  final List<String> flavorIds;
  final int quantity;
  final String? note;

  AddToCartRequestModel({
    required this.productId,
    required this.productSizeId,
    required this.flavorIds,
    required this.quantity,
    this.note,
  });

  Map<String, dynamic> toJson() => _$AddToCartRequestModelToJson(this);

  factory AddToCartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AddToCartRequestModelFromJson(json);
}
