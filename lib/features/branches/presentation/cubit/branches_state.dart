part of 'branches_cubit.dart';

sealed class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object?> get props => [];
}

class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

class BranchesLoaded extends BranchesState {
  final PaginatedBranchesEntity branches;
  const BranchesLoaded(this.branches);

  @override
  List<Object?> get props => [branches];
}

class BranchesFailure extends BranchesState {
  final String message;
  const BranchesFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchByIdLoading extends BranchesState {
  const BranchByIdLoading();
}

class BranchByIdLoaded extends BranchesState {
  final BranchEntity branch;
  const BranchByIdLoaded(this.branch);

  @override
  List<Object?> get props => [branch];
}

class BranchByIdFailure extends BranchesState {
  final String message;
  const BranchByIdFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchActionLoading extends BranchesState {
  const BranchActionLoading();
}

class BranchActionSuccess extends BranchesState {
  final String message;
  const BranchActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchActionFailure extends BranchesState {
  final String message;
  const BranchActionFailure(this.message);

  @override
  List<Object?> get props => [message];
}
