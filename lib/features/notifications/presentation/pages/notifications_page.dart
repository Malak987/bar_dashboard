import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../cubit/notification_center_cubit.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  NotificationType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DashboardScaffold(
      pageTitle: l10n.notifications,
      pageSubtitle: l10n.notificationsPageSubtitle,
      pageIcon: Icons.notifications,
      headerAction:
          BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${state.unreadCount} ${l10n.unreadLabel}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: state.items.isEmpty
                    ? null
                    : () => context
                        .read<NotificationCenterCubit>()
                        .markAllAsRead(),
                icon: const Icon(Icons.done_all, size: 16),
                label: Text(l10n.markAllReadAction),
              ),
            ],
          );
        },
      ),
      body: BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
        builder: (context, state) {
          final filtered = _selectedType == null
              ? state.items
              : state.items
                  .where((item) => item.type == _selectedType)
                  .toList();
          final criticalCount = state.items
              .where((item) => item.severity == NotificationSeverity.critical)
              .length;
          final todayCount = state.items.where((item) {
            final now = DateTime.now();
            return item.createdAt.year == now.year &&
                item.createdAt.month == now.month &&
                item.createdAt.day == now.day;
          }).length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _summaryCard(
                            l10n.unreadLabel,
                            '${state.unreadCount}',
                            Icons.mark_email_unread,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _summaryCard(
                            l10n.criticalLabel,
                            '$criticalCount',
                            Icons.warning_amber,
                            AppColors.error,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _summaryCard(
                            l10n.todayLabel,
                            '$todayCount',
                            Icons.today,
                            AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFilters(context),
                  ],
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty(context)
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _notificationCard(context, item);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _filterChip(context, l10n.allFilter, null),
        _filterChip(context, l10n.ordersFilter, NotificationType.order),
        _filterChip(context, l10n.branchesFilter, NotificationType.branch),
        _filterChip(context, l10n.customersFilter, NotificationType.user),
        _filterChip(context, l10n.systemLabel, NotificationType.system),
      ],
    );
  }

  Widget _filterChip(BuildContext context, String label, NotificationType? type) {
    final selected = _selectedType == type;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _selectedType = type),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: selected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
          Text(title,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
              )),
        ],
      ),
    );
  }

  Widget _notificationCard(BuildContext context, AppNotification item) {
    final cubit = context.read<NotificationCenterCubit>();
    final color = _colorForSeverity(item.severity);

    return GestureDetector(
      onTap: () => cubit.markAsRead(item.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead
              ? AppColors.surface
              : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.isRead
                ? AppColors.border
                : color.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconForType(item.type), color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: item.isRead
                                ? FontWeight.w600
                                : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.body,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _labelForType(context, item.type),
                          style: TextStyle(
                            color: color,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(item.createdAt),
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.notifications_off,
              size: 80, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            l10n.noNotifications,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: () => context.read<NotificationCenterCubit>().clearAll(),
            child: Text(l10n.clearList),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month}/${date.year} - $h:$m';
  }

  Color _colorForSeverity(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.normal:
        return AppColors.info;
      case NotificationSeverity.important:
        return AppColors.warning;
      case NotificationSeverity.critical:
        return AppColors.error;
    }
  }

  IconData _iconForType(NotificationType type) {
    switch (type) {
      case NotificationType.order:
        return Icons.shopping_cart;
      case NotificationType.system:
        return Icons.settings_suggest;
      case NotificationType.branch:
        return Icons.store;
      case NotificationType.user:
        return Icons.people;
      case NotificationType.alert:
        return Icons.notification_important;
    }
  }

  String _labelForType(BuildContext context, NotificationType type) {
    final l10n = context.l10n;
    switch (type) {
      case NotificationType.order:
        return l10n.ordersFilter;
      case NotificationType.system:
        return l10n.systemLabel;
      case NotificationType.branch:
        return l10n.branchesFilter;
      case NotificationType.user:
        return l10n.customersFilter;
      case NotificationType.alert:
        return l10n.alertLabel;
    }
  }
}
