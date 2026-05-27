part of 'cart_cubit.dart';

sealed class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartLoaded extends CartState {
  final CartEntity cart;
  const CartLoaded(this.cart);
  @override
  List<Object?> get props => [cart];
}

class CartFailure extends CartState {
  final String message;
  const CartFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Action states (Add/Update/Remove/Clear)
class CartActionLoading extends CartState {
  const CartActionLoading();
}

class CartActionSuccess extends CartState {
  final String message;
  const CartActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CartActionFailure extends CartState {
  final String message;
  const CartActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
