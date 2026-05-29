part of 'notification_center_cubit.dart';

enum NotificationType { order, system, branch, user, alert }

enum NotificationSeverity { normal, important, critical }

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final NotificationType type;
  final NotificationSeverity severity;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    required this.severity,
    required this.isRead,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      type: type,
      severity: severity,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        createdAt,
        type,
        severity,
        isRead,
      ];
}

class NotificationCenterState extends Equatable {
  final List<AppNotification> items;

  const NotificationCenterState({this.items = const []});

  int get unreadCount => items.where((item) => !item.isRead).length;

  @override
  List<Object?> get props => [items];
}
