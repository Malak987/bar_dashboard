import '../../../../core/utils/result.dart';
import '../entities/branch_entity.dart';
import '../entities/paginated_branches_entity.dart';

abstract class BranchesRepository {
  Future<Result<PaginatedBranchesEntity>> getAllBranches();

  Future<Result<BranchEntity>> getBranchById(String id);

  Future<Result<String>> addBranch({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  });

  Future<Result<String>> updateBranch({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  });

  Future<Result<String>> archiveBranch(String id);

  Future<Result<String>> unArchiveBranch(String id);
}
