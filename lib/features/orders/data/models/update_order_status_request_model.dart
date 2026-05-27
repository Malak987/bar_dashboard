import 'package:json_annotation/json_annotation.dart';

part 'update_order_status_request_model.g.dart';

@JsonSerializable()
class UpdateOrderStatusRequestModel {
  final String orderId;
  final int newStatus;

  UpdateOrderStatusRequestModel({
    required this.orderId,
    required this.newStatus,
  });

  Map<String, dynamic> toJson() =>
      _$UpdateOrderStatusRequestModelToJson(this);

  factory UpdateOrderStatusRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrderStatusRequestModelFromJson(json);
}
