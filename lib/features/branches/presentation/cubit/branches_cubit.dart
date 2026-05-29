import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/entities/paginated_branches_entity.dart';
import '../../domain/usecases/branches_usecases.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final GetAllBranchesUseCase _getAllBranchesUseCase;
  final GetBranchByIdUseCase _getBranchByIdUseCase;
  final AddBranchUseCase _addBranchUseCase;
  final UpdateBranchUseCase _updateBranchUseCase;
  final ArchiveBranchUseCase _archiveBranchUseCase;
  final UnArchiveBranchUseCase _unArchiveBranchUseCase;

  BranchesCubit(
    this._getAllBranchesUseCase,
    this._getBranchByIdUseCase,
    this._addBranchUseCase,
    this._updateBranchUseCase,
    this._archiveBranchUseCase,
    this._unArchiveBranchUseCase,
  ) : super(const BranchesInitial());

  Future<void> fetchAllBranches() async {
    emit(const BranchesLoading());
    final result = await _getAllBranchesUseCase();
    result.when(
      success: (branches) => emit(BranchesLoaded(branches)),
      failure: (f) => emit(BranchesFailure(f.message)),
    );
  }

  Future<void> silentRefreshAllBranches() async {
    final result = await _getAllBranchesUseCase();
    result.when(
      success: (branches) {
        final current = state;
        if (current is BranchesLoaded) {
          if (_branchesChanged(current.branches.items, branches.items) ||
              current.branches.totalCount != branches.totalCount) {
            emit(BranchesLoaded(branches));
          }
        } else {
          emit(BranchesLoaded(branches));
        }
      },
      failure: (_) {},
    );
  }

  bool _branchesChanged(List oldList, List newList) {
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
        if (o.nameAr != n.nameAr) return true;
        if (o.phone != n.phone) return true;
      } catch (_) {
        return true;
      }
    }
    return false;
  }

  Future<void> fetchBranchById(String id) async {
    emit(const BranchByIdLoading());
    final result = await _getBranchByIdUseCase(id);
    result.when(
      success: (branch) => emit(BranchByIdLoaded(branch)),
      failure: (f) => emit(BranchByIdFailure(f.message)),
    );
  }

  Future<void> addBranch({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) async {
    emit(const BranchActionLoading());
    final result = await _addBranchUseCase(
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      phone: phone,
      addressAr: addressAr,
      addressEn: addressEn,
    );
    result.when(
      success: (msg) {
        emit(BranchActionSuccess(msg));
        silentRefreshAllBranches();
      },
      failure: (f) => emit(BranchActionFailure(f.message)),
    );
  }

  Future<void> updateBranch({
    required String id,
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required String phone,
    required String addressAr,
    required String addressEn,
  }) async {
    emit(const BranchActionLoading());
    final result = await _updateBranchUseCase(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      phone: phone,
      addressAr: addressAr,
      addressEn: addressEn,
    );
    result.when(
      success: (msg) {
        emit(BranchActionSuccess(msg));
        silentRefreshAllBranches();
      },
      failure: (f) => emit(BranchActionFailure(f.message)),
    );
  }

  Future<void> archiveBranch(String id) async {
    emit(const BranchActionLoading());
    final result = await _archiveBranchUseCase(id);
    result.when(
      success: (msg) {
        emit(BranchActionSuccess(msg));
        silentRefreshAllBranches();
      },
      failure: (f) => emit(BranchActionFailure(f.message)),
    );
  }

  Future<void> unArchiveBranch(String id) async {
    emit(const BranchActionLoading());
    final result = await _unArchiveBranchUseCase(id);
    result.when(
      success: (msg) {
        emit(BranchActionSuccess(msg));
        silentRefreshAllBranches();
      },
      failure: (f) => emit(BranchActionFailure(f.message)),
    );
  }
}
