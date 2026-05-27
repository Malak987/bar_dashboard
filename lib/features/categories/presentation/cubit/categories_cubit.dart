import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/paginated_categories_entity.dart';
import '../../domain/usecases/add_category_usecase.dart';
import '../../domain/usecases/archive_category_usecase.dart';
import '../../domain/usecases/get_all_categories_usecase.dart';
import '../../domain/usecases/get_category_by_id_usecase.dart';
import '../../domain/usecases/update_category_usecase.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetAllCategoriesUseCase _getAllCategoriesUseCase;
  final GetCategoryByIdUseCase _getCategoryByIdUseCase;
  final AddCategoryUseCase _addCategoryUseCase;
  final UpdateCategoryUseCase _updateCategoryUseCase;
  final ArchiveCategoryUseCase _archiveCategoryUseCase;
  final UnArchiveCategoryUseCase _unArchiveCategoryUseCase;

  CategoriesCubit(
      this._getAllCategoriesUseCase,
      this._getCategoryByIdUseCase,
      this._addCategoryUseCase,
      this._updateCategoryUseCase,
      this._archiveCategoryUseCase,
      this._unArchiveCategoryUseCase,
      ) : super(const CategoriesInitial());

  Future<void> fetchAllCategories() async {
    emit(const CategoriesLoading());
    final result = await _getAllCategoriesUseCase();
    result.when(
      success: (cats) => emit(CategoriesLoaded(cats)),
      failure: (f) => emit(CategoriesFailure(f.message)),
    );
  }

  /// 🤫 Silent Refresh - بدون Loading state
  Future<void> silentRefreshAllCategories() async {
    final result = await _getAllCategoriesUseCase();
    result.when(
      success: (cats) {
        final current = state;
        if (current is CategoriesLoaded) {
          if (_categoriesChanged(current.categories.items, cats.items) ||
              current.categories.totalCount != cats.totalCount) {
            emit(CategoriesLoaded(cats));
          }
        } else {
          emit(CategoriesLoaded(cats));
        }
      },
      failure: (_) {},
    );
  }

  bool _categoriesChanged(List oldList, List newList) {
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
        if (o.productsCount != n.productsCount) return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchCategoryById(String id) async {
    emit(const CategoryByIdLoading());
    final result = await _getCategoryByIdUseCase(id);
    result.when(
      success: (cat) => emit(CategoryByIdLoaded(cat)),
      failure: (f) => emit(CategoryByIdFailure(f.message)),
    );
  }

  Future<void> addCategory({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required MultipartFile image,
  }) async {
    emit(const CategoryActionLoading());
    final result = await _addCategoryUseCase(
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      image: image,
    );
    result.when(
      success: (msg) {
        emit(CategoryActionSuccess(msg));
        silentRefreshAllCategories();
      },
      failure: (f) => emit(CategoryActionFailure(f.message)),
    );
  }

  Future<void> updateCategory({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    MultipartFile? image,
  }) async {
    emit(const CategoryActionLoading());
    final result = await _updateCategoryUseCase(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      image: image,
    );
    result.when(
      success: (msg) {
        emit(CategoryActionSuccess(msg));
        silentRefreshAllCategories();
      },
      failure: (f) => emit(CategoryActionFailure(f.message)),
    );
  }

  Future<void> archiveCategory(String id) async {
    emit(const CategoryActionLoading());
    final result = await _archiveCategoryUseCase(id);
    result.when(
      success: (msg) {
        emit(CategoryActionSuccess(msg));
        silentRefreshAllCategories();
      },
      failure: (f) => emit(CategoryActionFailure(f.message)),
    );
  }

  Future<void> unArchiveCategory(String id) async {
    emit(const CategoryActionLoading());
    final result = await _unArchiveCategoryUseCase(id);
    result.when(
      success: (msg) {
        emit(CategoryActionSuccess(msg));
        silentRefreshAllCategories();
      },
      failure: (f) => emit(CategoryActionFailure(f.message)),
    );
  }
}