import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/flavor_entity.dart';
import '../entities/paginated_flavors_entity.dart';

abstract class FlavorsRepository {
  Future<Result<PaginatedFlavorsEntity>> getAllFlavors();

  Future<Result<FlavorEntity>> getFlavorById(String id);

  Future<Result<String>> addFlavor({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  });

  Future<Result<String>> updateFlavor({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  });

  Future<Result<String>> archiveFlavor(String id);

  Future<Result<String>> unArchiveFlavor(String id);
}
