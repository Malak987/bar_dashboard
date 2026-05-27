import '../../../../core/utils/result.dart';
import '../entities/cart_entity.dart';
import '../repositories/carts_repository.dart';

class GetCartUseCase {
  final CartsRepository _repository;
  GetCartUseCase(this._repository);

  Future<Result<CartEntity>> call() => _repository.getCart();
}
