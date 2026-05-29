import 'package:dashboard_bar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/services/notification_sound_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../activity_log/presentation/cubit/activity_log_cubit.dart';
import '../../../notifications/presentation/cubit/notification_center_cubit.dart';
import '../cubit/settings_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DashboardScaffold(
      pageTitle: l10n.settingsPageTitle,
      pageSubtitle: l10n.settingsPageSubtitle,
      pageIcon: Icons.settings,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section(
                title: l10n.settingsSectionLanguage,
                icon: Icons.language,
                children: [
                  _languageRow(
                    l10n: l10n,
                    currentLocale: state.localeCode,
                    onChanged: (locale) =>
                        context.read<SettingsCubit>().setLocaleCode(locale),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                title: l10n.settingsSectionNotifications,
                icon: Icons.notifications_active,
                children: [
                  _switchRow(
                    title: l10n.soundEnabledTitle,
                    subtitle: l10n.soundEnabledSubtitle,
                    value: state.soundEnabled,
                    onChanged: (value) =>
                        context.read<SettingsCubit>().setSoundEnabled(value),
                  ),
                  _switchRow(
                    title: l10n.pushEnabledTitle,
                    subtitle: l10n.pushEnabledSubtitle,
                    value: state.pushNotificationsEnabled,
                    onChanged: (value) => context
                        .read<SettingsCubit>()
                        .setPushNotificationsEnabled(value),
                  ),
                  _actionRow(
                    title: l10n.testNotificationSound,
                    subtitle: l10n.testNotificationSoundSubtitle,
                    buttonLabel: l10n.testButton,
                    buttonIcon: Icons.volume_up,
                    onPressed: () async {
                      await NotificationSoundService().playStrongAlert();
                      context.read<NotificationCenterCubit>().addNotification(
                            AppNotification(
                              id: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              title: l10n.notificationSoundTestTitle,
                              body: l10n.notificationSoundTestBody,
                              createdAt: DateTime.now(),
                              type: NotificationType.alert,
                              severity: NotificationSeverity.normal,
                              isRead: false,
                            ),
                          );
                      context.read<ActivityLogCubit>().addEntry(
                            ActivityLogEntry(
                              id: DateTime.now()
                                  .microsecondsSinceEpoch
                                  .toString(),
                              title: l10n.notificationSoundTestTitle,
                              description: l10n.notificationSoundTestLog,
                              createdAt: DateTime.now(),
                              type: ActivityType.settings,
                              severity: ActivitySeverity.info,
                            ),
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                title: l10n.settingsSectionLiveUpdates,
                icon: Icons.sync,
                children: [
                  _switchRow(
                    title: l10n.autoRefreshTitle,
                    subtitle: l10n.autoRefreshSubtitle,
                    value: state.autoRefreshEnabled,
                    onChanged: (value) =>
                        context.read<SettingsCubit>().setAutoRefreshEnabled(value),
                  ),
                  _switchRow(
                    title: l10n.analyticsRealtimeTitle,
                    subtitle: l10n.analyticsRealtimeSubtitle,
                    value: state.analyticsRealtimeEnabled,
                    onChanged: (value) => context
                        .read<SettingsCubit>()
                        .setAnalyticsRealtimeEnabled(value),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                title: l10n.settingsSectionBehavior,
                icon: Icons.tune,
                children: [
                  _switchRow(
                    title: l10n.showClosedBranchesTitle,
                    subtitle: l10n.showClosedBranchesSubtitle,
                    value: state.showClosedBranches,
                    onChanged: (value) =>
                        context.read<SettingsCubit>().setShowClosedBranches(value),
                  ),
                  _switchRow(
                    title: l10n.confirmationsTitle,
                    subtitle: l10n.confirmationsSubtitle,
                    value: state.requireConfirmations,
                    onChanged: (value) => context
                        .read<SettingsCubit>()
                        .setRequireConfirmations(value),
                  ),
                  _switchRow(
                    title: l10n.compactModeTitle,
                    subtitle: l10n.compactModeSubtitle,
                    value: state.compactMode,
                    onChanged: (value) =>
                        context.read<SettingsCubit>().setCompactMode(value),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                title: l10n.settingsSectionSecurity,
                icon: Icons.security,
                children: [
                  _InfoRow(
                    title: l10n.securityLevelTitle,
                    subtitle: l10n.securityLevelSubtitle,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _section(
                title: l10n.settingsSectionSystem,
                icon: Icons.info_outline,
                children: [
                  _InfoValueRow(title: l10n.appVersion, value: 'v2.0'),
                  _InfoValueRow(
                    title: l10n.systemStatus,
                    value: l10n.systemReady,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _switchRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _actionRow({
    required String title,
    required String subtitle,
    required String buttonLabel,
    required IconData buttonIcon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(buttonIcon, size: 16),
            label: Text(buttonLabel),
          ),
        ],
      ),
    );
  }

  Widget _languageRow({
    required AppLocalizations l10n,
    required String currentLocale,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _languageOption(
              label: l10n.arabic,
              selected: currentLocale == 'ar',
              onTap: () => onChanged('ar'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _languageOption(
              label: l10n.english,
              selected: currentLocale == 'en',
              onTap: () => onChanged('en'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageOption({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color:
          selected ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoRow({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoValueRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoValueRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: value == 'Ready' || value == 'جاهز'
                  ? AppColors.success
                  : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
