import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/category_entity.dart';
import '../entities/paginated_categories_entity.dart';

abstract class CategoriesRepository {
  Future<Result<PaginatedCategoriesEntity>> getAllCategories();

  Future<Result<CategoryEntity>> getCategoryById(String id);

  Future<Result<String>> addCategory({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required MultipartFile image,
  });

  Future<Result<String>> updateCategory({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    MultipartFile? image,
  });

  Future<Result<String>> archiveCategory(String id);

  Future<Result<String>> unArchiveCategory(String id);
}
