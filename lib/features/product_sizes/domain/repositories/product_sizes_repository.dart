import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../entities/product_size_entity.dart';

abstract class ProductSizesRepository {
  Future<Result<List<ProductSizeEntity>>> getProductSizes(String productId);

  Future<Result<String>> addProductSize({
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
  });

  Future<Result<String>> updateProductSize({
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
  });

  Future<Result<String>> archiveProductSize(String id);
}
