import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_entity.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartItemModel extends CartItemEntity {
  const CartItemModel({
    super.id,
    super.productId,
    super.productName,
    super.productSizeId,
    super.flavorIds,
    required super.quantity,
    super.price,
    super.note,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CartModel extends CartEntity {
  @JsonKey(name: 'cartItems')
  final List<CartItemModel> cartItemModels;

  const CartModel({
    required super.id,
    required super.userId,
    required this.cartItemModels,
    required super.totalPrice,
  }) : super(cartItems: cartItemModels);

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
