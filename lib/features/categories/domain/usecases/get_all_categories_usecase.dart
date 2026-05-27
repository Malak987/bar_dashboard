import '../../../../core/utils/result.dart';
import '../entities/paginated_categories_entity.dart';
import '../repositories/categories_repository.dart';

class GetAllCategoriesUseCase {
  final CategoriesRepository _repository;
  GetAllCategoriesUseCase(this._repository);

  Future<Result<PaginatedCategoriesEntity>> call() =>
      _repository.getAllCategories();
}
