part of 'categories_cubit.dart';

sealed class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

// List states
class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final PaginatedCategoriesEntity categories;
  const CategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class CategoriesFailure extends CategoriesState {
  final String message;
  const CategoriesFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Single category states
class CategoryByIdLoading extends CategoriesState {
  const CategoryByIdLoading();
}

class CategoryByIdLoaded extends CategoriesState {
  final CategoryEntity category;
  const CategoryByIdLoaded(this.category);
  @override
  List<Object?> get props => [category];
}

class CategoryByIdFailure extends CategoriesState {
  final String message;
  const CategoryByIdFailure(this.message);
  @override
  List<Object?> get props => [message];
}

// Action states (Add/Update/Archive/UnArchive)
class CategoryActionLoading extends CategoriesState {
  const CategoryActionLoading();
}

class CategoryActionSuccess extends CategoriesState {
  final String message;
  const CategoryActionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoryActionFailure extends CategoriesState {
  final String message;
  const CategoryActionFailure(this.message);
  @override
  List<Object?> get props => [message];
}
