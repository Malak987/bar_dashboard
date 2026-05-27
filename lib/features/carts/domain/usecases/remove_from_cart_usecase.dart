import '../../../../core/utils/result.dart';
import '../repositories/carts_repository.dart';

class RemoveFromCartUseCase {
  final CartsRepository _repository;
  RemoveFromCartUseCase(this._repository);

  Future<Result<String>> call(String id) => _repository.removeFromCart(id);
}
