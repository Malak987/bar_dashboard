import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/add_to_cart_usecase.dart';
import '../../domain/usecases/clear_cart_usecase.dart';
import '../../domain/usecases/get_cart_usecase.dart';
import '../../domain/usecases/remove_from_cart_usecase.dart';
import '../../domain/usecases/update_cart_item_quantity_usecase.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final UpdateCartItemQuantityUseCase _updateCartItemQuantityUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartCubit(
    this._getCartUseCase,
    this._addToCartUseCase,
    this._updateCartItemQuantityUseCase,
    this._removeFromCartUseCase,
    this._clearCartUseCase,
  ) : super(const CartInitial());

  Future<void> getCart() async {
    emit(const CartLoading());
    final result = await _getCartUseCase();
    result.when(
      success: (cart) => emit(CartLoaded(cart)),
      failure: (f) => emit(CartFailure(f.message)),
    );
  }

  Future<void> addToCart({
    required String productId,
    required String productSizeId,
    required List<String> flavorIds,
    required int quantity,
    String? note,
  }) async {
    emit(const CartActionLoading());
    final result = await _addToCartUseCase(
      productId: productId,
      productSizeId: productSizeId,
      flavorIds: flavorIds,
      quantity: quantity,
      note: note,
    );
    result.when(
      success: (msg) {
        emit(CartActionSuccess(msg));
        getCart(); // refresh
      },
      failure: (f) => emit(CartActionFailure(f.message)),
    );
  }

  Future<void> updateQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    emit(const CartActionLoading());
    final result = await _updateCartItemQuantityUseCase(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    result.when(
      success: (msg) {
        emit(CartActionSuccess(msg));
        getCart();
      },
      failure: (f) => emit(CartActionFailure(f.message)),
    );
  }

  Future<void> removeFromCart(String id) async {
    emit(const CartActionLoading());
    final result = await _removeFromCartUseCase(id);
    result.when(
      success: (msg) {
        emit(CartActionSuccess(msg));
        getCart();
      },
      failure: (f) => emit(CartActionFailure(f.message)),
    );
  }

  Future<void> clearCart() async {
    emit(const CartActionLoading());
    final result = await _clearCartUseCase();
    result.when(
      success: (msg) {
        emit(CartActionSuccess(msg));
        getCart();
      },
      failure: (f) => emit(CartActionFailure(f.message)),
    );
  }
}
