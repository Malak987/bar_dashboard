import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/flavor_entity.dart';
import '../../domain/entities/paginated_flavors_entity.dart';
import '../../domain/usecases/flavors_usecases.dart';

part 'flavors_state.dart';

class FlavorsCubit extends Cubit<FlavorsState> {
  final GetAllFlavorsUseCase _getAllFlavorsUseCase;
  final GetFlavorByIdUseCase _getFlavorByIdUseCase;
  final AddFlavorUseCase _addFlavorUseCase;
  final UpdateFlavorUseCase _updateFlavorUseCase;
  final ArchiveFlavorUseCase _archiveFlavorUseCase;
  final UnArchiveFlavorUseCase _unArchiveFlavorUseCase;

  FlavorsCubit(
      this._getAllFlavorsUseCase,
      this._getFlavorByIdUseCase,
      this._addFlavorUseCase,
      this._updateFlavorUseCase,
      this._archiveFlavorUseCase,
      this._unArchiveFlavorUseCase,
      ) : super(const FlavorsInitial());

  Future<void> fetchAllFlavors() async {
    emit(const FlavorsLoading());
    final result = await _getAllFlavorsUseCase();
    result.when(
      success: (flavors) => emit(FlavorsLoaded(flavors)),
      failure: (f) => emit(FlavorsFailure(f.message)),
    );
  }

  /// 🤫 Silent Refresh - بدون Loading state
  Future<void> silentRefreshAllFlavors() async {
    final result = await _getAllFlavorsUseCase();
    result.when(
      success: (flavors) {
        final current = state;
        if (current is FlavorsLoaded) {
          if (_flavorsChanged(current.flavors.items, flavors.items) ||
              current.flavors.totalCount != flavors.totalCount) {
            emit(FlavorsLoaded(flavors));
          }
        } else {
          emit(FlavorsLoaded(flavors));
        }
      },
      failure: (_) {},
    );
  }

  bool _flavorsChanged(List oldList, List newList) {
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
        if (o.isAvailable != n.isAvailable) return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchFlavorById(String id) async {
    emit(const FlavorByIdLoading());
    final result = await _getFlavorByIdUseCase(id);
    result.when(
      success: (flavor) => emit(FlavorByIdLoaded(flavor)),
      failure: (f) => emit(FlavorByIdFailure(f.message)),
    );
  }

  Future<void> addFlavor({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  }) async {
    emit(const FlavorActionLoading());
    final result = await _addFlavorUseCase(
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      isAvailable: isAvailable,
      image: image,
    );
    result.when(
      success: (msg) {
        emit(FlavorActionSuccess(msg));
        silentRefreshAllFlavors();
      },
      failure: (f) => emit(FlavorActionFailure(f.message)),
    );
  }

  Future<void> updateFlavor({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required bool isAvailable,
    MultipartFile? image,
  }) async {
    emit(const FlavorActionLoading());
    final result = await _updateFlavorUseCase(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      isAvailable: isAvailable,
      image: image,
    );
    result.when(
      success: (msg) {
        emit(FlavorActionSuccess(msg));
        silentRefreshAllFlavors();
      },
      failure: (f) => emit(FlavorActionFailure(f.message)),
    );
  }

  Future<void> archiveFlavor(String id) async {
    emit(const FlavorActionLoading());
    final result = await _archiveFlavorUseCase(id);
    result.when(
      success: (msg) {
        emit(FlavorActionSuccess(msg));
        silentRefreshAllFlavors();
      },
      failure: (f) => emit(FlavorActionFailure(f.message)),
    );
  }

  Future<void> unArchiveFlavor(String id) async {
    emit(const FlavorActionLoading());
    final result = await _unArchiveFlavorUseCase(id);
    result.when(
      success: (msg) {
        emit(FlavorActionSuccess(msg));
        silentRefreshAllFlavors();
      },
      failure: (f) => emit(FlavorActionFailure(f.message)),
    );
  }
}
