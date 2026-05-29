import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/entities/paginated_branches_entity.dart';
import '../../domain/repositories/branches_repository.dart';
import '../datasources/branches_web_service.dart';

class BranchesRepositoryImpl implements BranchesRepository {
  final BranchesWebService _webService;

  BranchesRepositoryImpl(this._webService);

  @override
  Future<Result<PaginatedBranchesEntity>> getAllBranches() async {
    try {
      final response = await _webService.getAllBranches();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تحميل الفروع'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<BranchEntity>> getBranchById(String id) async {
    try {
      final response = await _webService.getBranchById(id);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
        ServerFailure(response.message ?? 'الفرع غير موجود'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> addBranch({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) async {
    try {
      final response = await _webService.addBranch(
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        phone: phone,
        addressAr: addressAr,
        addressEn: addressEn,
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تمت إضافة الفرع',
        );
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل إضافة الفرع'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> updateBranch({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) async {
    try {
      final response = await _webService.updateBranch(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        phone: phone,
        addressAr: addressAr,
        addressEn: addressEn,
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تم تعديل الفرع',
        );
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل تعديل الفرع'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> archiveBranch(String id) async {
    try {
      final response = await _webService.archiveBranch(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم إيقاف الفرع');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل إيقاف الفرع'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> unArchiveBranch(String id) async {
    try {
      final response = await _webService.unArchiveBranch(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تمت إعادة تشغيل الفرع');
      }
      return FailureResult(
        ServerFailure(response.message ?? 'فشل إعادة تشغيل الفرع'),
      );
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
