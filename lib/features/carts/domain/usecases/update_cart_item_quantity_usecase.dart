import '../../../../core/utils/result.dart';
import '../repositories/carts_repository.dart';

class UpdateCartItemQuantityUseCase {
  final CartsRepository _repository;
  UpdateCartItemQuantityUseCase(this._repository);

  Future<Result<String>> call({
    required String cartItemId,
    required int quantity,
  }) {
    return _repository.updateCartItemQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
  }
}
