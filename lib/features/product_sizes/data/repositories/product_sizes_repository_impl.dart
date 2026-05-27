import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/product_size_entity.dart';
import '../../domain/repositories/product_sizes_repository.dart';
import '../datasources/product_sizes_web_service.dart';

class ProductSizesRepositoryImpl implements ProductSizesRepository {
  final ProductSizesWebService _webService;

  ProductSizesRepositoryImpl(this._webService);

  @override
  Future<Result<List<ProductSizeEntity>>> getProductSizes(
      String productId) async {
    try {
      final response = await _webService.getProductSizes(productId);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل تحميل الأحجام'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
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
  }) async {
    // ✅ Logging تفصيلي عشان نشوف كل حاجة
    developer.log('═══════════════════════════════════════════', name: 'AddSize');
    developer.log('🟢 AddProductSize - بدء الإضافة', name: 'AddSize');
    developer.log('  productId: $productId', name: 'AddSize');
    developer.log('  nameAr: $nameAr', name: 'AddSize');
    developer.log('  nameEn: $nameEn', name: 'AddSize');
    developer.log('  sizeName: $sizeName', name: 'AddSize');
    developer.log('  price: $price', name: 'AddSize');
    developer.log('  radius: $radius', name: 'AddSize');
    developer.log('  height: $height', name: 'AddSize');
    developer.log('  serves: $serves', name: 'AddSize');
    developer.log('  isAvailable: $isAvailable', name: 'AddSize');
    developer.log('  image: ${image != null ? "✅ موجودة" : "❌ مفيش"}',
        name: 'AddSize');

    // 1️⃣ التحقق من صحة الـ productId قبل الإرسال
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    if (!uuidRegex.hasMatch(productId)) {
      developer.log('❌ productId مش UUID صحيح: $productId', name: 'AddSize');
      return FailureResult(ServerFailure(
        'معرّف المنتج غير صحيح ($productId).\n'
            'يجب أن يكون بصيغة UUID. تأكد من اختيار منتج موجود.',
      ));
    }

    try {
      final response = await _webService.addProductSize(
        productId: productId,
        nameAr: nameAr,
        nameEn: nameEn,
        sizeName: sizeName,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        price: price.toString(),
        isAvailable: isAvailable.toString(),
        radius: radius.toString(),
        height: height.toString(),
        serves: serves,
        image: image,
      );

      developer.log(
          '📥 Response: isSucceeded=${response.isSucceeded}, message=${response.message}, data=${response.data}',
          name: 'AddSize');

      if (response.isSucceeded) {
        developer.log('✅ تم بنجاح', name: 'AddSize');
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تم الإضافة',
        );
      }
      developer.log('❌ السيرفر رفض: ${response.message}', name: 'AddSize');
      return FailureResult(
          ServerFailure(response.message ?? 'فشل الإضافة'));
    } on DioException catch (e) {
      developer.log('❌ DioException: ${e.message}', name: 'AddSize');
      developer.log('   Status: ${e.response?.statusCode}', name: 'AddSize');
      developer.log('   Data: ${e.response?.data}', name: 'AddSize');

      // محاولة قراءة الـ message من الـ response
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return FailureResult(ServerFailure(
          'فشل الإضافة: ${data['message']}',
          statusCode: e.response?.statusCode,
        ));
      }
      return FailureResult(ServerFailure(
        'فشل الإضافة (${e.response?.statusCode ?? "Network Error"}): ${e.message}',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      developer.log('❌ Unexpected error: $e', name: 'AddSize');
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
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
  }) async {
    try {
      final response = await _webService.updateProductSize(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        price: price.toString(),
        isAvailable: isAvailable.toString(),
        radius: radius.toString(),
        height: height.toString(),
        serves: serves,
        image: image,
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تم التعديل',
        );
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل التعديل'));
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return FailureResult(ServerFailure(
          'فشل التعديل: ${data['message']}',
          statusCode: e.response?.statusCode,
        ));
      }
      return FailureResult(ErrorHandler.handle(e));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> archiveProductSize(String id) async {
    try {
      final response = await _webService.archiveProductSize(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم الأرشفة');
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل الأرشفة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
