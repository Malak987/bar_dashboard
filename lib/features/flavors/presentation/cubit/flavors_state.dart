part of 'flavors_cubit.dart';

sealed class FlavorsState extends Equatable {
  const FlavorsState();
  @override
  List<Object?> get props => [];
}

class FlavorsInitial extends FlavorsState {
  const FlavorsInitial();
}

// List
class FlavorsLoading extends FlavorsState {
  const FlavorsLoading();
}

class FlavorsLoaded extends FlavorsState {
  final PaginatedFlavorsEntity flavors;
  const FlavorsLoaded(this.flavors);
  @override
  List<Object?> get props => [flavors];
}

class FlavorsFailure extends FlavorsState {
  final String message;
  const FlavorsFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Single
class FlavorByIdLoading extends FlavorsState {
  const FlavorByIdLoading();
}

class FlavorByIdLoaded extends FlavorsState {
  final FlavorEntity flavor;
  const FlavorByIdLoaded(this.flavor);
  @override
  List<Object?> get props => [flavor];
}

class FlavorByIdFailure extends FlavorsState {
  final String message;
  const FlavorByIdFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Actions
class FlavorActionLoading extends FlavorsState {
  const FlavorActionLoading();
}

class FlavorActionSuccess extends FlavorsState {
  final String message;
  const FlavorActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class FlavorActionFailure extends FlavorsState {
  final String message;
  const FlavorActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
