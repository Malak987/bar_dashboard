import '../../../../core/utils/result.dart';
import '../repositories/carts_repository.dart';

class ClearCartUseCase {
  final CartsRepository _repository;
  ClearCartUseCase(this._repository);

  Future<Result<String>> call() => _repository.clearCart();
}
