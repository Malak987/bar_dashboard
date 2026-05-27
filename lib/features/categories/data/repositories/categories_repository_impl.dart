import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/paginated_categories_entity.dart';
import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_web_service.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoriesWebService _webService;

  CategoriesRepositoryImpl(this._webService);

  @override
  Future<Result<PaginatedCategoriesEntity>> getAllCategories() async {
    try {
      final response = await _webService.getAllCategories();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل تحميل الفئات'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<CategoryEntity>> getCategoryById(String id) async {
    try {
      final response = await _webService.getCategoryById(id);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'الفئة غير موجودة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> addCategory({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required MultipartFile image,
  }) async {
    try {
      final response = await _webService.addCategory(
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        image: image,
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تم الإضافة',
        );
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل الإضافة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> updateCategory({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    MultipartFile? image,
  }) async {
    try {
      final response = await _webService.updateCategory(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        image: image,
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تم التعديل',
        );
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل التعديل'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> archiveCategory(String id) async {
    try {
      final response = await _webService.archiveCategory(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم الأرشفة');
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل الأرشفة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> unArchiveCategory(String id) async {
    try {
      final response = await _webService.unArchiveCategory(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم إلغاء الأرشفة');
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل إلغاء الأرشفة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
