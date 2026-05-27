import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_size_entity.dart';
import '../repositories/product_sizes_repository.dart';

class GetProductSizesUseCase {
  final ProductSizesRepository _repository;
  GetProductSizesUseCase(this._repository);
  Future<Result<List<ProductSizeEntity>>> call(String productId) =>
      _repository.getProductSizes(productId);
}

class AddProductSizeUseCase {
  final ProductSizesRepository _repository;
  AddProductSizeUseCase(this._repository);
  Future<Result<String>> call({
    required String productId,
    required String nameAr,
    required String nameEn,
    required String sizeName,
    required String descriptionAr,
    required String descriptionEn,
    required double price,
    required bool isAvailable,
    required double radius,
    required double height,
    required String serves,
    MultipartFile? image,
  }) =>
      _repository.addProductSize(
        productId: productId,
        nameAr: nameAr,
        nameEn: nameEn,
        sizeName: sizeName,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        price: price,
        isAvailable: isAvailable,
        radius: radius,
        height: height,
        serves: serves,
        image: image,
      );
}

class UpdateProductSizeUseCase {
  final ProductSizesRepository _repository;
  UpdateProductSizeUseCase(this._repository);
  Future<Result<String>> call({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required double price,
    required bool isAvailable,
    required double radius,
    required double height,
    required String serves,
    MultipartFile? image,
  }) =>
      _repository.updateProductSize(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        price: price,
        isAvailable: isAvailable,
        radius: radius,
        height: height,
        serves: serves,
        image: image,
      );
}

class ArchiveProductSizeUseCase {
  final ProductSizesRepository _repository;
  ArchiveProductSizeUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.archiveProductSize(id);
}
