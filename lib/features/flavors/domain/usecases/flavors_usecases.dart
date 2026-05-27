import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/flavor_entity.dart';
import '../entities/paginated_flavors_entity.dart';
import '../repositories/flavors_repository.dart';

class GetAllFlavorsUseCase {
  final FlavorsRepository _repository;
  GetAllFlavorsUseCase(this._repository);
  Future<Result<PaginatedFlavorsEntity>> call() => _repository.getAllFlavors();
}

class GetFlavorByIdUseCase {
  final FlavorsRepository _repository;
  GetFlavorByIdUseCase(this._repository);
  Future<Result<FlavorEntity>> call(String id) =>
      _repository.getFlavorById(id);
}

class AddFlavorUseCase {
  final FlavorsRepository _repository;
  AddFlavorUseCase(this._repository);
  Future<Result<String>> call({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  }) =>
      _repository.addFlavor(
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        isAvailable: isAvailable,
        image: image,
      );
}

class UpdateFlavorUseCase {
  final FlavorsRepository _repository;
  UpdateFlavorUseCase(this._repository);
  Future<Result<String>> call({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  }) =>
      _repository.updateFlavor(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        isAvailable: isAvailable,
        image: image,
      );
}

class ArchiveFlavorUseCase {
  final FlavorsRepository _repository;
  ArchiveFlavorUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.archiveFlavor(id);
}

class UnArchiveFlavorUseCase {
  final FlavorsRepository _repository;
  UnArchiveFlavorUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.unArchiveFlavor(id);
}
