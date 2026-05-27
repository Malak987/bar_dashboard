import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../repositories/categories_repository.dart';

class UpdateCategoryUseCase {
  final CategoriesRepository _repository;
  UpdateCategoryUseCase(this._repository);

  Future<Result<String>> call({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    MultipartFile? image,
  }) {
    return _repository.updateCategory(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      image: image,
    );
  }
}
