import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/branch_selection/branch_selection_cubit.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../accounts/presentation/cubit/auth_cubit.dart';
import '../../../activity_log/presentation/cubit/activity_log_cubit.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../../../branches/presentation/cubit/branches_cubit.dart';
import '../../../notifications/presentation/cubit/notification_center_cubit.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1100;
    final isVerySmall = width < 700;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isVerySmall ? 8 : 16,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          Expanded(
            child: isMobile
                ? const _MobileBranchSelector()
                : _DesktopBranchSelector(isVerySmall: isVerySmall),
          ),
          const SizedBox(width: 8),
          if (!isMobile)
            SizedBox(
              width: 220,
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.searchHint,
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
          if (!isMobile) const SizedBox(width: 12),
          const _LanguageButton(),
          const SizedBox(width: 4),
          const _NotificationsButton(),
          if (!isVerySmall) const SizedBox(width: 4),
          if (!isVerySmall) const _ActivityButton(),
          if (!isVerySmall) const SizedBox(width: 4),
          if (!isVerySmall) const _SettingsShortcutButton(),
          const SizedBox(width: 8),
          _UserChip(compact: isVerySmall),
        ],
      ),
    );
  }
}

class _DesktopBranchSelector extends StatelessWidget {
  final bool isVerySmall;

  const _DesktopBranchSelector({required this.isVerySmall});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<BranchesCubit, BranchesState>(
      buildWhen: (previous, current) {
        return current is BranchesInitial ||
            current is BranchesLoading ||
            current is BranchesLoaded ||
            current is BranchesFailure;
      },
      builder: (context, branchesState) {
        if (branchesState is BranchesInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<BranchesCubit>().fetchAllBranches();
            }
          });
        }

        final branches = branchesState is BranchesLoaded
            ? branchesState.branches.items
            : <BranchEntity>[];

        return BlocBuilder<BranchSelectionCubit, BranchSelectionState>(
          builder: (context, selectionState) {
            final selectedValue = selectionState.selectedBranchId;
            final hasSelectedBranch = selectedValue != null &&
                branches.any((branch) => branch.id == selectedValue);
            final dropdownValue = hasSelectedBranch ? selectedValue : '__all__';

            return Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.store, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        isExpanded: true,
                        dropdownColor: AppColors.surfaceLight,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.textSecondary,
                        ),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: '__all__',
                            child: Text(l10n.allBranches),
                          ),
                          ...branches.map(
                            (branch) => DropdownMenuItem<String>(
                              value: branch.id,
                              child: Text(
                                branch.isArchived
                                    ? '${branch.nameAr} (${l10n.branchClosedLabel})'
                                    : branch.nameAr,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null || value == '__all__') {
                            context
                                .read<BranchSelectionCubit>()
                                .selectAllBranches();
                            return;
                          }

                          final branch = branches.firstWhere(
                            (item) => item.id == value,
                          );
                          context.read<BranchSelectionCubit>().selectBranch(
                                id: branch.id,
                                name: branch.nameAr,
                              );
                        },
                      ),
                    ),
                  ),
                  if (branchesState is BranchesLoading)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  if (isVerySmall && selectionState.isAllBranches)
                    const SizedBox.shrink(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MobileBranchSelector extends StatelessWidget {
  const _MobileBranchSelector();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<BranchesCubit, BranchesState>(
      buildWhen: (previous, current) {
        return current is BranchesInitial ||
            current is BranchesLoading ||
            current is BranchesLoaded ||
            current is BranchesFailure;
      },
      builder: (context, branchesState) {
        if (branchesState is BranchesInitial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.read<BranchesCubit>().fetchAllBranches();
            }
          });
        }

        final branches = branchesState is BranchesLoaded
            ? branchesState.branches.items
            : <BranchEntity>[];

        return BlocBuilder<BranchSelectionCubit, BranchSelectionState>(
          builder: (context, selectionState) {
            final currentLabel = selectionState.isAllBranches
                ? l10n.allBranches
                : selectionState.selectedBranchName;

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _showBranchPicker(context, branches),
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.store, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        currentLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    if (branchesState is BranchesLoading)
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    else
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.textSecondary,
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBranchPicker(BuildContext context, List<BranchEntity> branches) {
    final l10n = context.l10n;
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: BlocBuilder<BranchSelectionCubit, BranchSelectionState>(
            builder: (context, selectionState) {
              return ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    l10n.allBranches,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: selectionState.isAllBranches
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surfaceLight,
                    leading: const Icon(Icons.storefront, color: AppColors.primary),
                    title: Text(
                      l10n.allBranches,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      context.read<BranchSelectionCubit>().selectAllBranches();
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                  const SizedBox(height: 8),
                  ...branches.map((branch) {
                    final selected = selectionState.selectedBranchId == branch.id;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: selected
                            ? AppColors.primary.withValues(alpha: 0.15)
                            : AppColors.surfaceLight,
                        leading: Icon(
                          branch.isArchived ? Icons.lock_clock : Icons.store,
                          color: branch.isArchived ? AppColors.error : AppColors.primary,
                        ),
                        title: Text(
                          branch.nameAr,
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        subtitle: branch.isArchived
                            ? Text(
                                l10n.branchClosedLabel,
                                style: const TextStyle(color: AppColors.error),
                              )
                            : null,
                        onTap: () {
                          context.read<BranchSelectionCubit>().selectBranch(
                                id: branch.id,
                                name: branch.nameAr,
                              );
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton();

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsCubit>().state;
    final l10n = context.l10n;

    return Tooltip(
      message: l10n.changeLanguage,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.read<SettingsCubit>().toggleLocale(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text(
                settingsState.isArabic ? 'AR' : 'EN',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsButton extends StatelessWidget {
  const _NotificationsButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCenterCubit, NotificationCenterState>(
      builder: (context, state) {
        final unreadCount = state.unreadCount;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_active_outlined,
                color: AppColors.textSecondary,
              ),
              tooltip: context.l10n.notifications,
              onPressed: () => _showNotificationsPreview(context, state),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  void _showNotificationsPreview(BuildContext context, NotificationCenterState state) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) {
        final latest = state.items.take(6).toList();
        return Dialog(
          backgroundColor: AppColors.surface,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.notifications_active, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.lastNotifications,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: state.items.isEmpty
                            ? null
                            : () => context.read<NotificationCenterCubit>().markAllAsRead(),
                        child: Text(l10n.markAllRead),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: latest.isEmpty
                        ? Center(
                            child: Text(
                              l10n.noNotifications,
                              style: const TextStyle(color: AppColors.textHint),
                            ),
                          )
                        : ListView.separated(
                            itemCount: latest.length,
                            separatorBuilder: (_, __) => const Divider(color: AppColors.border, height: 1),
                            itemBuilder: (_, index) {
                              final item = latest[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => context.read<NotificationCenterCubit>().markAsRead(item.id),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: item.isRead
                                        ? Colors.transparent
                                        : AppColors.primary.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.notifications,
                                        size: 18,
                                        color: item.isRead ? AppColors.textHint : AppColors.primary,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title,
                                              style: TextStyle(
                                                color: AppColors.textPrimary,
                                                fontWeight: item.isRead ? FontWeight.w500 : FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item.body,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: AppColors.textSecondary,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (!item.isRead)
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Icon(Icons.fiber_manual_record, size: 10, color: AppColors.primary),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).pushReplacementNamed(AppRoutes.notifications);
                      },
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: Text(l10n.openNotificationsPage),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ActivityButton extends StatelessWidget {
  const _ActivityButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityLogCubit, ActivityLogState>(
      builder: (context, state) {
        final warningCount = state.items.where((item) => item.severity != ActivitySeverity.info).length;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.history, color: AppColors.textSecondary),
              tooltip: context.l10n.activityLog,
              onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.activityLog),
            ),
            if (warningCount > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.warning,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SettingsShortcutButton extends StatelessWidget {
  const _SettingsShortcutButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: context.l10n.settings,
      onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.settings),
      icon: const Icon(Icons.settings_outlined, color: AppColors.textSecondary),
    );
  }
}

class _UserChip extends StatelessWidget {
  final bool compact;
  const _UserChip({this.compact = false});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final userName = state is LoginSuccess ? state.auth.userName : l10n.owner;
        return PopupMenuButton<String>(
          tooltip: l10n.userMenu,
          color: AppColors.surfaceLight,
          onSelected: (value) async {
            if (value == 'settings') {
              Navigator.of(context).pushReplacementNamed(AppRoutes.settings);
            } else if (value == 'notifications') {
              Navigator.of(context).pushReplacementNamed(AppRoutes.notifications);
            } else if (value == 'language') {
              await context.read<SettingsCubit>().toggleLocale();
            } else if (value == 'logout') {
              await context.read<AuthCubit>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (_) => false);
              }
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem<String>(
              value: 'notifications',
              child: _menuItemRow(Icons.notifications, l10n.notifications),
            ),
            PopupMenuItem<String>(
              value: 'settings',
              child: _menuItemRow(Icons.settings, l10n.settings),
            ),
            PopupMenuItem<String>(
              value: 'language',
              child: _menuItemRow(Icons.language, l10n.language),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: _menuItemRow(Icons.logout, l10n.logout, color: AppColors.error),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person, size: 14, color: Colors.white),
                ),
                if (!compact) ...[
                  const SizedBox(width: 8),
                  Text(
                    userName,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                  ),
                  const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 18),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItemRow(IconData icon, String text, {Color? color}) {
    final itemColor = color ?? AppColors.textPrimary;
    return Row(
      children: [
        Icon(icon, size: 18, color: itemColor),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: itemColor)),
      ],
    );
  }
}
