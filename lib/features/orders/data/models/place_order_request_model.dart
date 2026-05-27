import 'package:json_annotation/json_annotation.dart';

part 'place_order_request_model.g.dart';

@JsonSerializable()
class PlaceOrderRequestModel {
  final String address;
  final String? note;
  final double deliveryFee;

  PlaceOrderRequestModel({
    required this.address,
    this.note,
    required this.deliveryFee,
  });

  Map<String, dynamic> toJson() => _$PlaceOrderRequestModelToJson(this);

  factory PlaceOrderRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PlaceOrderRequestModelFromJson(json);
}
