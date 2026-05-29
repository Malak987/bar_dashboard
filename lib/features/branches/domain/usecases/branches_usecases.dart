import '../../../../core/utils/result.dart';
import '../entities/branch_entity.dart';
import '../entities/paginated_branches_entity.dart';
import '../repositories/branches_repository.dart';

class GetAllBranchesUseCase {
  final BranchesRepository _repository;
  GetAllBranchesUseCase(this._repository);
  Future<Result<PaginatedBranchesEntity>> call() => _repository.getAllBranches();
}

class GetBranchByIdUseCase {
  final BranchesRepository _repository;
  GetBranchByIdUseCase(this._repository);
  Future<Result<BranchEntity>> call(String id) => _repository.getBranchById(id);
}

class AddBranchUseCase {
  final BranchesRepository _repository;
  AddBranchUseCase(this._repository);

  Future<Result<String>> call({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) =>
      _repository.addBranch(
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        phone: phone,
        addressAr: addressAr,
        addressEn: addressEn,
      );
}

class UpdateBranchUseCase {
  final BranchesRepository _repository;
  UpdateBranchUseCase(this._repository);

  Future<Result<String>> call({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) =>
      _repository.updateBranch(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        phone: phone,
        addressAr: addressAr,
        addressEn: addressEn,
      );
}

class ArchiveBranchUseCase {
  final BranchesRepository _repository;
  ArchiveBranchUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.archiveBranch(id);
}

class UnArchiveBranchUseCase {
  final BranchesRepository _repository;
  UnArchiveBranchUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.unArchiveBranch(id);
}
