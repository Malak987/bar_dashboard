import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BranchSelectionState extends Equatable {
  final String? selectedBranchId;
  final String selectedBranchName;

  const BranchSelectionState({
    required this.selectedBranchId,
    required this.selectedBranchName,
  });

  const BranchSelectionState.all()
      : selectedBranchId = null,
        selectedBranchName = 'كل الفروع';

  bool get isAllBranches => selectedBranchId == null || selectedBranchId!.isEmpty;

  @override
  List<Object?> get props => [selectedBranchId, selectedBranchName];
}

class BranchSelectionCubit extends Cubit<BranchSelectionState> {
  BranchSelectionCubit() : super(const BranchSelectionState.all());

  void selectAllBranches() {
    emit(const BranchSelectionState.all());
  }

  void selectBranch({
    required String id,
    required String name,
  }) {
    emit(BranchSelectionState(selectedBranchId: id, selectedBranchName: name));
  }
}
