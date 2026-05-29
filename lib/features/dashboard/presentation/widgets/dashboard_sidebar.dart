import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../accounts/presentation/cubit/auth_cubit.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    return Material(
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => _navigate(context, AppRoutes.dashboard),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/bar_logo.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BAR Sweets',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          l10n.dashboard,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [
                _NavItem(
                  icon: Icons.dashboard,
                  label: l10n.dashboard,
                  route: AppRoutes.dashboard,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.shopping_cart,
                  label: l10n.orders,
                  route: AppRoutes.orders,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.cake,
                  label: l10n.products,
                  route: AppRoutes.products,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.category,
                  label: l10n.categories,
                  route: AppRoutes.categories,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.local_drink,
                  label: l10n.flavors,
                  route: AppRoutes.flavors,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.inventory_2,
                  label: l10n.inventory,
                  route: AppRoutes.inventory,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.people,
                  label: l10n.customers,
                  route: AppRoutes.customers,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.badge,
                  label: l10n.employees,
                  route: AppRoutes.employees,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.discount,
                  label: l10n.coupons,
                  route: AppRoutes.coupons,
                  currentRoute: currentRoute,
                ),
                const SizedBox(height: 12),
                _NavItem(
                  icon: Icons.assessment,
                  label: l10n.reports,
                  route: AppRoutes.reports,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.analytics,
                  label: l10n.analytics,
                  route: AppRoutes.analytics,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.store,
                  label: l10n.branches,
                  route: AppRoutes.branches,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.notifications,
                  label: l10n.notifications,
                  route: AppRoutes.notifications,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.history,
                  label: l10n.activityLog,
                  route: AppRoutes.activityLog,
                  currentRoute: currentRoute,
                ),
                _NavItem(
                  icon: Icons.settings,
                  label: l10n.settings,
                  route: AppRoutes.settings,
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final userName = state is LoginSuccess ? state.auth.userName : l10n.owner;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            l10n.owner,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: AppColors.error,
                        size: 20,
                      ),
                      tooltip: l10n.logout,
                      onPressed: () async {
                        await context.read<AuthCubit>().logout();
                        if (context.mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoutes.login,
                            (_) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final String currentRoute;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final selected = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
              Navigator.of(context).pop();
            }
            if (currentRoute != route) {
              Navigator.of(context).pushReplacementNamed(route);
            }
          },
          hoverColor: selected
              ? Colors.white.withValues(alpha: 0.1)
              : AppColors.primary.withValues(alpha: 0.1),
          splashColor: selected
              ? Colors.white.withValues(alpha: 0.2)
              : AppColors.primary.withValues(alpha: 0.2),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? Colors.white : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (selected)
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
