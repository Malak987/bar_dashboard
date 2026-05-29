import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../cubit/activity_log_cubit.dart';

class ActivityLogPage extends StatefulWidget {
  const ActivityLogPage({super.key});

  @override
  State<ActivityLogPage> createState() => _ActivityLogPageState();
}

class _ActivityLogPageState extends State<ActivityLogPage> {
  ActivityType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DashboardScaffold(
      pageTitle: l10n.activityLog,
      pageSubtitle: l10n.activityPageSubtitle,
      pageIcon: Icons.history,
      headerAction: BlocBuilder<ActivityLogCubit, ActivityLogState>(
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
                  '${state.items.length} ${l10n.eventsWord}',
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
                    : () => context.read<ActivityLogCubit>().clearAll(),
                icon: const Icon(Icons.delete_sweep, size: 16),
                label: Text(l10n.clearLog),
              ),
            ],
          );
        },
      ),
      body: BlocBuilder<ActivityLogCubit, ActivityLogState>(
        builder: (context, state) {
          final filtered = _selectedType == null
              ? state.items
              : state.items.where((item) => item.type == _selectedType).toList();
          final criticalCount = state.items
              .where((item) => item.severity == ActivitySeverity.critical)
              .length;
          final warnings = state.items
              .where((item) => item.severity == ActivitySeverity.warning)
              .length;

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
                            l10n.overallLabel,
                            '${state.items.length}',
                            Icons.timeline,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _summaryCard(
                            l10n.warningsLabel,
                            '$warnings',
                            Icons.warning_amber,
                            AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _summaryCard(
                            l10n.criticalLabel,
                            '$criticalCount',
                            Icons.report_gmailerrorred,
                            AppColors.error,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          return _timelineItem(context, item, index == filtered.length - 1);
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
        _filterChip(context, l10n.ordersFilter, ActivityType.order),
        _filterChip(context, l10n.branchesFilter, ActivityType.branch),
        _filterChip(context, l10n.customersFilter, ActivityType.user),
        _filterChip(context, l10n.loginLabel, ActivityType.login),
        _filterChip(context, l10n.systemLabel, ActivityType.system),
      ],
    );
  }

  Widget _filterChip(BuildContext context, String label, ActivityType? type) {
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
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(BuildContext context, ActivityLogEntry item, bool isLast) {
    final color = _colorForSeverity(item.severity);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 38,
          child: Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              if (!isLast)
                Container(width: 2, height: 82, color: AppColors.border),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      _labelForType(context, item.type),
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDate(item.createdAt),
                  style: const TextStyle(
                    color: AppColors.textHint,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.history_toggle_off, size: 80, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            context.l10n.noActivity,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
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

  Color _colorForSeverity(ActivitySeverity severity) {
    switch (severity) {
      case ActivitySeverity.info:
        return AppColors.info;
      case ActivitySeverity.warning:
        return AppColors.warning;
      case ActivitySeverity.critical:
        return AppColors.error;
    }
  }

  String _labelForType(BuildContext context, ActivityType type) {
    final l10n = context.l10n;
    switch (type) {
      case ActivityType.login:
        return l10n.loginLabel;
      case ActivityType.order:
        return l10n.activityTypeOrder;
      case ActivityType.branch:
        return l10n.activityTypeBranch;
      case ActivityType.user:
        return l10n.activityTypeUser;
      case ActivityType.system:
        return l10n.activityTypeSystem;
      case ActivityType.settings:
        return l10n.activityTypeSettings;
    }
  }
}
