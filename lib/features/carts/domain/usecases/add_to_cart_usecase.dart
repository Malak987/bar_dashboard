import '../../../../core/utils/result.dart';
import '../repositories/carts_repository.dart';

class AddToCartUseCase {
  final CartsRepository _repository;
  AddToCartUseCase(this._repository);

  Future<Result<String>> call({
    required String productId,
    required String productSizeId,
    required List<String> flavorIds,
    required int quantity,
    String? note,
  }) {
    return _repository.addToCart(
      productId: productId,
      productSizeId: productSizeId,
      flavorIds: flavorIds,
      quantity: quantity,
      note: note,
    );
  }
}
