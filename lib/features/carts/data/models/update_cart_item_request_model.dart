import 'package:json_annotation/json_annotation.dart';

part 'update_cart_item_request_model.g.dart';

@JsonSerializable()
class UpdateCartItemRequestModel {
  final String cartItemId;
  final int quantity;

  UpdateCartItemRequestModel({
    required this.cartItemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => _$UpdateCartItemRequestModelToJson(this);

  factory UpdateCartItemRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateCartItemRequestModelFromJson(json);
}
