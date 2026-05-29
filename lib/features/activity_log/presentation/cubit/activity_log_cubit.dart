import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'activity_log_state.dart';

class ActivityLogCubit extends Cubit<ActivityLogState> {
  ActivityLogCubit() : super(const ActivityLogState());

  void addEntry(ActivityLogEntry entry) {
    final items = [entry, ...state.items];
    emit(ActivityLogState(items: items.take(400).toList()));
  }

  void clearAll() {
    emit(const ActivityLogState());
  }
}
