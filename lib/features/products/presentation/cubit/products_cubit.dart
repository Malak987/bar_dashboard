import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/paginated_products_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../../domain/usecases/products_usecases.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final GetAllProductsUseCase _getAllProductsUseCase;
  final GetProductByIdUseCase _getProductByIdUseCase;
  final AddProductUseCase _addProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;
  final ArchiveProductUseCase _archiveProductUseCase;
  final UnArchiveProductUseCase _unArchiveProductUseCase;
  final AssignFlavorsToProductUseCase _assignFlavorsToProductUseCase;

  ProductsCubit(
      this._getAllProductsUseCase,
      this._getProductByIdUseCase,
      this._addProductUseCase,
      this._updateProductUseCase,
      this._archiveProductUseCase,
      this._unArchiveProductUseCase,
      this._assignFlavorsToProductUseCase,
      ) : super(const ProductsInitial());

  Future<void> fetchAllProducts() async {
    emit(const ProductsLoading());
    final result = await _getAllProductsUseCase();
    result.when(
      success: (p) => emit(ProductsLoaded(p)),
      failure: (f) => emit(ProductsFailure(f.message)),
    );
  }

  /// 🤫 Silent Refresh - بدون Loading state (مفيش رفرفة)
  Future<void> silentRefreshAllProducts() async {
    final result = await _getAllProductsUseCase();
    result.when(
      success: (p) {
        final current = state;
        if (current is ProductsLoaded) {
          if (current.products.totalCount != p.totalCount ||
              _productsChanged(current.products.items, p.items)) {
            emit(ProductsLoaded(p));
          }
        } else {
          emit(ProductsLoaded(p));
        }
      },
      failure: (_) {},
    );
  }

  bool _productsChanged(List oldList, List newList) {
    if (oldList.length != newList.length) return true;
    final oldMap = <String, dynamic>{};
    for (final item in oldList) {
      try {
        oldMap[(item as dynamic).id as String] = item;
      } catch (_) {
        return true;
      }
    }
    for (final newItem in newList) {
      try {
        final dynamic n = newItem;
        final dynamic o = oldMap[n.id as String];
        if (o == null) return true;
        if (o.isArchived != n.isArchived) return true;
        if (o.basePrice != n.basePrice) return true;
        if (o.isFeatured != n.isFeatured) return true;
        if (o.isBestSeller != n.isBestSeller) return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchProductById(String id) async {
    emit(const ProductByIdLoading());
    final result = await _getProductByIdUseCase(id);
    result.when(
      success: (p) => emit(ProductByIdLoaded(p)),
      failure: (f) => emit(ProductByIdFailure(f.message)),
    );
  }

  Future<void> addProduct({
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
    emit(const ProductActionLoading());
    final result = await _addProductUseCase(
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
    result.when(
      success: (msg) {
        emit(ProductActionSuccess(msg));
        silentRefreshAllProducts();
      },
      failure: (f) => emit(ProductActionFailure(f.message)),
    );
  }

  Future<void> updateProduct({
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
    emit(const ProductActionLoading());
    final result = await _updateProductUseCase(
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
    result.when(
      success: (msg) {
        emit(ProductActionSuccess(msg));
        silentRefreshAllProducts();
      },
      failure: (f) => emit(ProductActionFailure(f.message)),
    );
  }

  Future<void> archiveProduct(String id) async {
    emit(const ProductActionLoading());
    final result = await _archiveProductUseCase(id);
    result.when(
      success: (msg) {
        emit(ProductActionSuccess(msg));
        silentRefreshAllProducts();
      },
      failure: (f) => emit(ProductActionFailure(f.message)),
    );
  }

  Future<void> unArchiveProduct(String id) async {
    emit(const ProductActionLoading());
    final result = await _unArchiveProductUseCase(id);
    result.when(
      success: (msg) {
        emit(ProductActionSuccess(msg));
        silentRefreshAllProducts();
      },
      failure: (f) => emit(ProductActionFailure(f.message)),
    );
  }

  Future<void> assignFlavorsToProduct({
    required String productId,
    required List<FlavorAssignment> flavors,
  }) async {
    emit(const ProductActionLoading());
    final result = await _assignFlavorsToProductUseCase(
      productId: productId,
      flavors: flavors,
    );
    result.when(
      success: (msg) {
        emit(ProductActionSuccess(msg));
        silentRefreshAllProducts();
      },
      failure: (f) => emit(ProductActionFailure(f.message)),
    );
  }
}