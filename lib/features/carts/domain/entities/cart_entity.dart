import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String id;
  final String userId;
  final List<CartItemEntity> cartItems;
  final double totalPrice;

  const CartEntity({
    required this.id,
    required this.userId,
    required this.cartItems,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [id, userId, cartItems, totalPrice];
}

class CartItemEntity extends Equatable {
  final String? id;
  final String? productId;
  final String? productName;
  final String? productSizeId;
  final List<String>? flavorIds;
  final int quantity;
  final double? price;
  final String? note;

  const CartItemEntity({
    this.id,
    this.productId,
    this.productName,
    this.productSizeId,
    this.flavorIds,
    required this.quantity,
    this.price,
    this.note,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        productName,
        productSizeId,
        flavorIds,
        quantity,
        price,
        note,
      ];
}
