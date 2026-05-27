import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/paginated_products_entity.dart';
import '../entities/product_entity.dart';

/// 🆕 wrapper بسيط للنكهة + سعرها الإضافي
class FlavorAssignment {
  final String flavorId;
  final double extraPrice;
  const FlavorAssignment({required this.flavorId, this.extraPrice = 0});
}

abstract class ProductsRepository {
  Future<Result<PaginatedProductsEntity>> getAllProducts();

  Future<Result<ProductEntity>> getProductById(String id);

  /// 🆕 بحقول جديدة: basePrice + isCustomizable + sizeName
  /// 🔄 بترجع productId لما النجاح (عشان نقدر نضيف sizes/flavors بعدها)
  Future<Result<String>> addProduct({
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
  });

  Future<Result<String>> updateProduct({
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
  });

  Future<Result<String>> archiveProduct(String id);
  Future<Result<String>> unArchiveProduct(String id);

  /// 🆕 بـ extraPrice لكل نكهة
  Future<Result<String>> assignFlavorsToProduct({
    required String productId,
    required List<FlavorAssignment> flavors,
  });
}
