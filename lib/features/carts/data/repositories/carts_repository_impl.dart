import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/carts_repository.dart';
import '../datasources/carts_web_service.dart';
import '../models/add_to_cart_request_model.dart';
import '../models/update_cart_item_request_model.dart';

class CartsRepositoryImpl implements CartsRepository {
  final CartsWebService _webService;

  CartsRepositoryImpl(this._webService);

  @override
  Future<Result<CartEntity>> getCart() async {
    try {
      final response = await _webService.getCart();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تحميل السلة'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> addToCart({
    required String productId,
    required String productSizeId,
    required List<String> flavorIds,
    required int quantity,
    String? note,
  }) async {
    try {
      final response = await _webService.addToCart(
        AddToCartRequestModel(
          productId: productId,
          productSizeId: productSizeId,
          flavorIds: flavorIds,
          quantity: quantity,
          note: note,
        ),
      );
      if (response.isSucceeded) {
        return Success(response.message ?? 'تمت الإضافة بنجاح');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل الإضافة للسلة'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await _webService.updateCartItemQuantity(
        UpdateCartItemRequestModel(
          cartItemId: cartItemId,
          quantity: quantity,
        ),
      );
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم التحديث بنجاح');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل التحديث'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> removeFromCart(String id) async {
    try {
      final response = await _webService.removeFromCart(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم الحذف بنجاح');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل الحذف'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> clearCart() async {
    try {
      final response = await _webService.clearCart();
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم تفريغ السلة بنجاح');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تفريغ السلة'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
