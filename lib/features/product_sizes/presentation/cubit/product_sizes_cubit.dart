import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_size_entity.dart';
import '../../domain/usecases/product_sizes_usecases.dart';

part 'product_sizes_state.dart';

class ProductSizesCubit extends Cubit<ProductSizesState> {
  final GetProductSizesUseCase _getProductSizesUseCase;
  final AddProductSizeUseCase _addProductSizeUseCase;
  final UpdateProductSizeUseCase _updateProductSizeUseCase;
  final ArchiveProductSizeUseCase _archiveProductSizeUseCase;

  String? _currentProductId;

  ProductSizesCubit(
      this._getProductSizesUseCase,
      this._addProductSizeUseCase,
      this._updateProductSizeUseCase,
      this._archiveProductSizeUseCase,
      ) : super(const ProductSizesInitial());

  Future<void> fetchProductSizes(String productId) async {
    _currentProductId = productId;
    emit(const ProductSizesLoading());
    final result = await _getProductSizesUseCase(productId);
    result.when(
      success: (sizes) => emit(ProductSizesLoaded(sizes)),
      failure: (f) => emit(ProductSizesFailure(f.message)),
    );
  }

  /// 🆕 يرجع true لو نجح، false + رسالة الخطأ لو فشل
  /// عشان _saveAllSizes يقدر يجمع الأخطاء
  Future<({bool success, String? errorMessage})> addProductSize({
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
    emit(const ProductSizeActionLoading());
    final result = await _addProductSizeUseCase(
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

    bool ok = false;
    String? errMsg;

    result.when(
      success: (msg) {
        developer.log('✅ Cubit Success: $msg', name: 'AddSize');
        emit(ProductSizeActionSuccess(msg));
        ok = true;
      },
      failure: (f) {
        developer.log('❌ Cubit Failure: ${f.message}', name: 'AddSize');
        emit(ProductSizeActionFailure(f.message));
        errMsg = f.message;
      },
    );

    return (success: ok, errorMessage: errMsg);
  }

  Future<({bool success, String? errorMessage})> updateProductSize({
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
    emit(const ProductSizeActionLoading());
    final result = await _updateProductSizeUseCase(
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

    bool ok = false;
    String? errMsg;

    result.when(
      success: (msg) {
        emit(ProductSizeActionSuccess(msg));
        if (_currentProductId != null) {
          fetchProductSizes(_currentProductId!);
        }
        ok = true;
      },
      failure: (f) {
        emit(ProductSizeActionFailure(f.message));
        errMsg = f.message;
      },
    );

    return (success: ok, errorMessage: errMsg);
  }

  Future<void> archiveProductSize(String id) async {
    emit(const ProductSizeActionLoading());
    final result = await _archiveProductSizeUseCase(id);
    result.when(
      success: (msg) {
        emit(ProductSizeActionSuccess(msg));
        if (_currentProductId != null) {
          fetchProductSizes(_currentProductId!);
        }
      },
      failure: (f) => emit(ProductSizeActionFailure(f.message)),
    );
  }
}
