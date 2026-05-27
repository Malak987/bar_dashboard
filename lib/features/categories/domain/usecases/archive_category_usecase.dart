import '../../../../core/utils/result.dart';
import '../repositories/categories_repository.dart';

class ArchiveCategoryUseCase {
  final CategoriesRepository _repository;
  ArchiveCategoryUseCase(this._repository);

  Future<Result<String>> call(String id) => _repository.archiveCategory(id);
}

class UnArchiveCategoryUseCase {
  final CategoriesRepository _repository;
  UnArchiveCategoryUseCase(this._repository);

  Future<Result<String>> call(String id) => _repository.unArchiveCategory(id);
}
