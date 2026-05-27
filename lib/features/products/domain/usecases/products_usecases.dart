import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/paginated_products_entity.dart';
import '../entities/product_entity.dart';
import '../repositories/products_repository.dart';

class GetAllProductsUseCase {
  final ProductsRepository _repository;
  GetAllProductsUseCase(this._repository);
  Future<Result<PaginatedProductsEntity>> call() =>
      _repository.getAllProducts();
}

class GetProductByIdUseCase {
  final ProductsRepository _repository;
  GetProductByIdUseCase(this._repository);
  Future<Result<ProductEntity>> call(String id) =>
      _repository.getProductById(id);
}

class AddProductUseCase {
  final ProductsRepository _repository;
  AddProductUseCase(this._repository);
  Future<Result<String>> call({
    required String nameAr,
    required String nameEn,
    required String sizeName,
    required String descriptionAr,
    required String descriptionEn,
    required double basePrice,
    required bool isFeatured,
    required bool isBestSeller,
    required bool isCustomizable,
    required String categoryId,
    MultipartFile? image,
  }) =>
      _repository.addProduct(
        nameAr: nameAr,
        nameEn: nameEn,
        sizeName: sizeName,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        basePrice: basePrice,
        isFeatured: isFeatured,
        isBestSeller: isBestSeller,
        isCustomizable: isCustomizable,
        categoryId: categoryId,
        image: image,
      );
}

class UpdateProductUseCase {
  final ProductsRepository _repository;
  UpdateProductUseCase(this._repository);
  Future<Result<String>> call({
    required String id,
    required String nameAr,
    required String nameEn,
    required String sizeName,
    required String descriptionAr,
    required String descriptionEn,
    required double basePrice,
    required bool isFeatured,
    required bool isBestSeller,
    required bool isCustomizable,
    required String categoryId,
    MultipartFile? image,
  }) =>
      _repository.updateProduct(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        sizeName: sizeName,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        basePrice: basePrice,
        isFeatured: isFeatured,
        isBestSeller: isBestSeller,
        isCustomizable: isCustomizable,
        categoryId: categoryId,
        image: image,
      );
}

class ArchiveProductUseCase {
  final ProductsRepository _repository;
  ArchiveProductUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.archiveProduct(id);
}

class UnArchiveProductUseCase {
  final ProductsRepository _repository;
  UnArchiveProductUseCase(this._repository);
  Future<Result<String>> call(String id) => _repository.unArchiveProduct(id);
}

class AssignFlavorsToProductUseCase {
  final ProductsRepository _repository;
  AssignFlavorsToProductUseCase(this._repository);
  Future<Result<String>> call({
    required String productId,
    required List<FlavorAssignment> flavors,
  }) =>
      _repository.assignFlavorsToProduct(
        productId: productId,
        flavors: flavors,
      );
}
