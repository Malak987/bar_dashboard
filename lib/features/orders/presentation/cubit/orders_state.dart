part of 'orders_cubit.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();
  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

// List
class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {
  final PaginatedOrdersEntity orders;
  const OrdersLoaded(this.orders);
  @override
  List<Object?> get props => [orders];
}

class OrdersFailure extends OrdersState {
  final String message;
  const OrdersFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Single
class OrderByIdLoading extends OrdersState {
  const OrderByIdLoading();
}

class OrderByIdLoaded extends OrdersState {
  final OrderEntity order;
  const OrderByIdLoaded(this.order);
  @override
  List<Object?> get props => [order];
}

class OrderByIdFailure extends OrdersState {
  final String message;
  const OrderByIdFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Actions
class OrderActionLoading extends OrdersState {
  const OrderActionLoading();
}

class OrderActionSuccess extends OrdersState {
  final String message;
  const OrderActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class OrderActionFailure extends OrdersState {
  final String message;
  const OrderActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
