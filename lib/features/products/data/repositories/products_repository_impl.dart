import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/paginated_products_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../datasources/products_web_service.dart';
import '../models/assign_flavors_request_model.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsWebService _webService;

  ProductsRepositoryImpl(this._webService);

  /// 🎯 Helper: يشيك على ID شكله UUID
  bool _looksLikeUuid(String s) {
    if (s.length < 30) return false;
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return uuidRegex.hasMatch(s);
  }

  @override
  Future<Result<PaginatedProductsEntity>> getAllProducts() async {
    try {
      final response = await _webService.getAllProducts();
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل تحميل المنتجات'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    try {
      final response = await _webService.getProductById(id);
      if (response.isSucceeded && response.data != null) {
        return Success(response.data!);
      }
      return FailureResult(
          ServerFailure(response.message ?? 'المنتج غير موجود'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
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
  }) async {
    try {
      developer.log('🟢 AddProduct: $nameAr', name: 'AddProduct');

      final response = await _webService.addProduct(
        nameAr: nameAr,
        nameEn: nameEn,
        sizeName: sizeName,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        basePrice: basePrice.toString(),
        isFeatured: isFeatured.toString(),
        isBestSeller: isBestSeller.toString(),
        isCustomizable: isCustomizable.toString(),
        categoryId: categoryId,
        image: image,
      );

      if (!response.isSucceeded) {
        developer.log('❌ Backend rejected: ${response.message}',
            name: 'AddProduct');
        return FailureResult(
            ServerFailure(response.message ?? 'فشل الإضافة'));
      }

      developer.log('✅ Backend success. data=${response.data}',
          name: 'AddProduct');

      // 1️⃣ لو الـ data نفسها UUID (الباك إند الجديد بيرجع ID)
      final dataStr = response.data?.toString() ?? '';
      if (_looksLikeUuid(dataStr)) {
        developer.log('✅ ID من الـ data: $dataStr', name: 'AddProduct');
        return Success(dataStr);
      }

      // 2️⃣ نجيب القائمة ونبحث عن المنتج بنفس الاسم
      developer.log('🔍 جاري البحث عن المنتج في القائمة...',
          name: 'AddProduct');

      try {
        final allProductsResp = await _webService.getAllProducts();
        if (allProductsResp.isSucceeded &&
            allProductsResp.data != null) {
          // نبحث بنفس nameAr + nameEn + categoryId
          final matching = allProductsResp.data!.items.where((p) {
            return p.nameAr.trim() == nameAr.trim() &&
                p.nameEn.trim() == nameEn.trim() &&
                p.categoryId == categoryId;
          }).toList();

          developer.log('🔍 وجد ${matching.length} منتج مطابق',
              name: 'AddProduct');

          if (matching.isNotEmpty) {
            // ناخد الأحدث (آخر واحد)
            final foundId = matching.last.id;
            developer.log('✅ تم استخراج ID: $foundId', name: 'AddProduct');
            return Success(foundId);
          }
        }
      } catch (e) {
        developer.log('⚠️ فشل البحث: $e', name: 'AddProduct');
      }

      // 3️⃣ لو ما لقيناش، نرجع الـ message لكن مع تنبيه
      developer.log('⚠️ لم يتم العثور على ID. سيتم استخدام الـ message',
          name: 'AddProduct');
      return Success(response.message ?? 'تم الإضافة بنجاح');
    } catch (e) {
      developer.log('❌ Exception: $e', name: 'AddProduct');
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
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
  }) async {
    try {
      final response = await _webService.updateProduct(
        id: id,
        nameAr: nameAr,
        nameEn: nameEn,
        sizeName: sizeName,
        descriptionAr: descriptionAr,
        descriptionEn: descriptionEn,
        basePrice: basePrice.toString(),
        isFeatured: isFeatured.toString(),
        isBestSeller: isBestSeller.toString(),
        isCustomizable: isCustomizable.toString(),
        categoryId: categoryId,
        image: image,
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ?? response.message ?? 'تم التعديل',
        );
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل التعديل'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> archiveProduct(String id) async {
    try {
      final response = await _webService.archiveProduct(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم الأرشفة');
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل الأرشفة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> unArchiveProduct(String id) async {
    try {
      final response = await _webService.unArchiveProduct(id);
      if (response.isSucceeded) {
        return Success(response.message ?? 'تم إلغاء الأرشفة');
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل إلغاء الأرشفة'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> assignFlavorsToProduct({
    required String productId,
    required List<FlavorAssignment> flavors,
  }) async {
    try {
      final response = await _webService.assignFlavorsToProduct(
        AssignFlavorsRequestModel(
          productId: productId,
          flavors: flavors
              .map((f) => FlavorWithExtraPriceModel(
            flavorId: f.flavorId,
            extraPrice: f.extraPrice,
          ))
              .toList(),
        ),
      );
      if (response.isSucceeded) {
        return Success(
          (response.data?.toString()) ??
              response.message ??
              'تم تحديث النكهات',
        );
      }
      return FailureResult(
          ServerFailure(response.message ?? 'فشل تحديث النكهات'));
    } catch (e) {
      return FailureResult(ErrorHandler.handle(e));
    }
  }
}
