import '../../../../core/utils/result.dart';
import '../entities/cart_entity.dart';

abstract class CartsRepository {
  Future<Result<CartEntity>> getCart();

  Future<Result<String>> addToCart({
    required String productId,
    required String productSizeId,
    required List<String> flavorIds,
    required int quantity,
    String? note,
  });

  Future<Result<String>> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  });

  Future<Result<String>> removeFromCart(String id);

  Future<Result<String>> clearCart();
}
