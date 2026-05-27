import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_item_entity.dart';

part 'order_item_model.g.dart';

@JsonSerializable()
class OrderItemFlavorModel extends OrderItemFlavorEntity {
  const OrderItemFlavorModel({
    required super.flavorId,
    super.flavorNameAr,
    super.flavorNameEn,
  });

  factory OrderItemFlavorModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFlavorModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemFlavorModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OrderItemModel extends OrderItemEntity {
  @JsonKey(name: 'flavors')
  final List<OrderItemFlavorModel> flavorModels;

  const OrderItemModel({
    required super.id,
    super.productId,
    super.productNameAr,
    super.productNameEn,
    super.productImageUrl,
    super.sizeId,
    super.sizeName,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    super.note,
    required this.flavorModels,
  }) : super(flavors: flavorModels);

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
