import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notification_center_state.dart';

class NotificationCenterCubit extends Cubit<NotificationCenterState> {
  NotificationCenterCubit() : super(const NotificationCenterState());

  void addNotification(AppNotification notification) {
    final items = [notification, ...state.items];
    emit(NotificationCenterState(items: items.take(200).toList()));
  }

  void markAllAsRead() {
    emit(
      NotificationCenterState(
        items: state.items
            .map((item) => item.copyWith(isRead: true))
            .toList(),
      ),
    );
  }

  void markAsRead(String id) {
    emit(
      NotificationCenterState(
        items: state.items
            .map((item) => item.id == id ? item.copyWith(isRead: true) : item)
            .toList(),
      ),
    );
  }

  void clearAll() {
    emit(const NotificationCenterState());
  }
}
