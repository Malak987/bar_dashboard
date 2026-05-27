part of 'products_cubit.dart';

sealed class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object?> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final PaginatedProductsEntity products;
  const ProductsLoaded(this.products);
  @override
  List<Object?> get props => [products];
}

class ProductsFailure extends ProductsState {
  final String message;
  const ProductsFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Single
class ProductByIdLoading extends ProductsState {
  const ProductByIdLoading();
}

class ProductByIdLoaded extends ProductsState {
  final ProductEntity product;
  const ProductByIdLoaded(this.product);
  @override
  List<Object?> get props => [product];
}

class ProductByIdFailure extends ProductsState {
  final String message;
  const ProductByIdFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Actions
class ProductActionLoading extends ProductsState {
  const ProductActionLoading();
}

class ProductActionSuccess extends ProductsState {
  final String message;
  const ProductActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductActionFailure extends ProductsState {
  final String message;
  const ProductActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
