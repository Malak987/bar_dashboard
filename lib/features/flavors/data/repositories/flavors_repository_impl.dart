import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/flavor_entity.dart';
import '../../domain/entities/paginated_flavors_entity.dart';
import '../../domain/repositories/flavors_repository.dart';
import '../datasources/flavors_web_service.dart';

class FlavorsRepositoryImpl implements FlavorsRepository {
  final FlavorsWebService _webService;

  FlavorsRepositoryImpl(this._webService);

  @override
  Future<Result<PaginatedFlavorsEntity>> getAllFlavors() async {
    try {
      final response = await _webService.getAllFlavors();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل تحميل النكهات'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<FlavorEntity>> getFlavorById(String id) async {
    try {
      final response = await _webService.getFlavorById(id);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'النكهة غير موجودة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> addFlavor({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  }) async {
    try {
      final response = await _webService.addFlavor(
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        isAvailable: isAvailable.toString(),
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
  Future<Result<String>> updateFlavor({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  }) async {
    try {
      final response = await _webService.updateFlavor(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        isAvailable: isAvailable.toString(),
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
  Future<Result<String>> archiveFlavor(String id) async {
    try {
      final response = await _webService.archiveFlavor(id);
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
  Future<Result<String>> unArchiveFlavor(String id) async {
    try {
      final response = await _webService.unArchiveFlavor(id);
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
