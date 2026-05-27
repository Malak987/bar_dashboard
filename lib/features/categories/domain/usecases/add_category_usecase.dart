import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../repositories/categories_repository.dart';

class AddCategoryUseCase {
  final CategoriesRepository _repository;
  AddCategoryUseCase(this._repository);

  Future<Result<String>> call({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required MultipartFile image,
  }) {
    return _repository.addCategory(
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      image: image,
    );
  }
}
