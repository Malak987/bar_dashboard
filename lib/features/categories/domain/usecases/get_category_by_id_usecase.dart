import '../../../../core/utils/result.dart';
import '../entities/category_entity.dart';
import '../repositories/categories_repository.dart';

class GetCategoryByIdUseCase {
  final CategoriesRepository _repository;
  GetCategoryByIdUseCase(this._repository);

  Future<Result<CategoryEntity>> call(String id) =>
      _repository.getCategoryById(id);
}
