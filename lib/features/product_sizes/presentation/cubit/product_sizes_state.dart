part of 'product_sizes_cubit.dart';

sealed class ProductSizesState extends Equatable {
  const ProductSizesState();
  @override
  List<Object?> get props => [];
}

class ProductSizesInitial extends ProductSizesState {
  const ProductSizesInitial();
}

class ProductSizesLoading extends ProductSizesState {
  const ProductSizesLoading();
}

class ProductSizesLoaded extends ProductSizesState {
  final List<ProductSizeEntity> sizes;
  const ProductSizesLoaded(this.sizes);
  @override
  List<Object?> get props => [sizes];
}

class ProductSizesFailure extends ProductSizesState {
  final String message;
  const ProductSizesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Actions
class ProductSizeActionLoading extends ProductSizesState {
  const ProductSizeActionLoading();
}

class ProductSizeActionSuccess extends ProductSizesState {
  final String message;
  const ProductSizeActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ProductSizeActionFailure extends ProductSizesState {
  final String message;
  const ProductSizeActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
