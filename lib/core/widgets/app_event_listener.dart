import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection_container.dart' as di;
import '../services/notification_sound_service.dart';
import '../../features/accounts/presentation/cubit/auth_cubit.dart';
import '../../features/accounts/presentation/cubit/users_cubit.dart';
import '../../features/activity_log/presentation/cubit/activity_log_cubit.dart';
import '../../features/branches/presentation/cubit/branches_cubit.dart';
import '../../features/notifications/presentation/cubit/notification_center_cubit.dart';
import '../../features/orders/domain/entities/order_entity.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../storage/auth_local_storage.dart';

class AppEventListener extends StatefulWidget {
  final Widget child;

  const AppEventListener({super.key, required this.child});

  @override
  State<AppEventListener> createState() => _AppEventListenerState();
}

class _AppEventListenerState extends State<AppEventListener> {
  final Set<String> _knownOrderIds = <String>{};
  Timer? _ordersPollingTimer;
  bool _soundPrimed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncKnownOrders();
      _restartPolling();
    });
  }

  @override
  void dispose() {
    _ordersPollingTimer?.cancel();
    super.dispose();
  }

  Future<void> _primeSoundIfNeeded() async {
    if (_soundPrimed) return;
    _soundPrimed = true;
    try {
      await NotificationSoundService().primeFromUserGesture();
    } catch (_) {}
  }

  void _syncKnownOrders() {
    final state = context.read<OrdersCubit>().state;
    if (state is OrdersLoaded) {
      _knownOrderIds
        ..clear()
        ..addAll(state.orders.items.map((order) => order.id));
    }
  }

  void _restartPolling() {
    _ordersPollingTimer?.cancel();

    final settings = context.read<SettingsCubit>().state;
    if (!settings.autoRefreshEnabled) return;

    _ordersPollingTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      final storage = di.sl<AuthLocalStorage>();
      if (!storage.isLoggedIn) return;
      context.read<OrdersCubit>().silentRefreshAllOrders();
    });
  }

  Future<void> _playStrongAlert() async {
    final settings = context.read<SettingsCubit>().state;
    if (!settings.soundEnabled || !settings.pushNotificationsEnabled) return;

    try {
      await NotificationSoundService().playStrongAlert();
    } catch (_) {
      await SystemSound.play(SystemSoundType.alert);
    }
    await HapticFeedback.heavyImpact();
  }

  void _pushNotification({
    required String title,
    required String body,
    required NotificationType type,
    NotificationSeverity severity = NotificationSeverity.normal,
  }) {
    context.read<NotificationCenterCubit>().addNotification(
          AppNotification(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            body: body,
            createdAt: DateTime.now(),
            type: type,
            severity: severity,
            isRead: false,
          ),
        );
  }

  void _logActivity({
    required String title,
    required String description,
    required ActivityType type,
    ActivitySeverity severity = ActivitySeverity.info,
  }) {
    context.read<ActivityLogCubit>().addEntry(
          ActivityLogEntry(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: title,
            description: description,
            createdAt: DateTime.now(),
            type: type,
            severity: severity,
          ),
        );
  }

  void _handleOrdersLoaded(OrdersLoaded state) {
    final orders = state.orders.items.cast<OrderEntity>();
    final currentIds = orders.map((order) => order.id).toSet();

    if (_knownOrderIds.isEmpty) {
      _knownOrderIds.addAll(currentIds);
      return;
    }

    final newOrders = orders
        .where((order) => !_knownOrderIds.contains(order.id))
        .toList(growable: false);

    if (newOrders.isNotEmpty) {
      for (final order in newOrders) {
        _pushNotification(
          title: 'طلب أونلاين جديد',
          body:
              'طلب جديد باسم ${order.userName} بقيمة ${order.totalAmount.toStringAsFixed(0)} جنيه',
          type: NotificationType.order,
          severity: NotificationSeverity.critical,
        );
        _logActivity(
          title: 'استلام طلب جديد',
          description:
              'تم استقبال طلب جديد للعميل ${order.userName} (رقم ${order.id.substring(0, 8).toUpperCase()})',
          type: ActivityType.order,
          severity: ActivitySeverity.critical,
        );
      }
      _playStrongAlert();
    }

    _knownOrderIds
      ..clear()
      ..addAll(currentIds);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) => _restartPolling(),
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              _logActivity(
                title: 'تسجيل دخول',
                description: 'تم تسجيل دخول ${state.auth.userName}',
                type: ActivityType.login,
              );
            } else if (state is LoggedOut) {
              _ordersPollingTimer?.cancel();
              _knownOrderIds.clear();
              _logActivity(
                title: 'تسجيل خروج',
                description: 'تم تسجيل الخروج من لوحة التحكم',
                type: ActivityType.login,
                severity: ActivitySeverity.warning,
              );
            }
          },
        ),
        BlocListener<OrdersCubit, OrdersState>(
          listener: (context, state) {
            if (state is OrdersLoaded) {
              _handleOrdersLoaded(state);
            } else if (state is OrderActionSuccess) {
              _pushNotification(
                title: 'تحديث على الطلبات',
                body: state.message,
                type: NotificationType.order,
                severity: NotificationSeverity.important,
              );
              _logActivity(
                title: 'إجراء على الطلبات',
                description: state.message,
                type: ActivityType.order,
              );
            }
          },
        ),
        BlocListener<BranchesCubit, BranchesState>(
          listener: (context, state) {
            if (state is BranchActionSuccess) {
              _pushNotification(
                title: 'تحديث الفروع',
                body: state.message,
                type: NotificationType.branch,
                severity: NotificationSeverity.important,
              );
              _logActivity(
                title: 'تعديل حالة فرع',
                description: state.message,
                type: ActivityType.branch,
                severity: ActivitySeverity.warning,
              );
            }
          },
        ),
        BlocListener<UsersCubit, UsersState>(
          listener: (context, state) {
            if (state is UserActionSuccess) {
              _pushNotification(
                title: 'تحديث العملاء',
                body: state.message,
                type: NotificationType.user,
                severity: NotificationSeverity.important,
              );
              _logActivity(
                title: 'إجراء على عميل',
                description: state.message,
                type: ActivityType.user,
                severity: ActivitySeverity.warning,
              );
            }
          },
        ),
      ],
      child: Listener(
        onPointerDown: (_) => _primeSoundIfNeeded(),
        child: widget.child,
      ),
    );
  }
}
