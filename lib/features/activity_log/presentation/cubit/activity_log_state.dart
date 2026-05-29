part of 'activity_log_cubit.dart';

enum ActivityType { login, order, branch, user, system, settings }

enum ActivitySeverity { info, warning, critical }

class ActivityLogEntry extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final ActivityType type;
  final ActivitySeverity severity;

  const ActivityLogEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.type,
    required this.severity,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        createdAt,
        type,
        severity,
      ];
}

class ActivityLogState extends Equatable {
  final List<ActivityLogEntry> items;

  const ActivityLogState({this.items = const []});

  @override
  List<Object?> get props => [items];
}
