import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/branch_selection/branch_selection_cubit.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/utils/branch_filter_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auto_refresh_mixin.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../products/presentation/cubit/products_cubit.dart';
import '../utils/dashboard_calculations.dart';
import '../widgets/stat_card.dart';
import '../widgets/recent_orders_section.dart';
import '../widgets/revenue_chart.dart';
import '../widgets/orders_status_chart.dart';
import '../widgets/top_products_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver, AutoRefreshMixin<DashboardPage> {
  DateTime _lastRefreshTime = DateTime.now();
  int _previousOrdersCount = 0;
  bool _isRefreshing = false;

  @override
  Duration get refreshInterval => const Duration(seconds: 30);

  @override
  Future<void> onRefresh() async {
    if (!mounted) return;

    final ordersState = context.read<OrdersCubit>().state;
    if (ordersState is OrdersLoaded) {
      _previousOrdersCount = ordersState.orders.totalCount;
    }

    if (mounted) setState(() => _isRefreshing = true);

    await Future.wait([
      context.read<OrdersCubit>().silentRefreshAllOrders(),
      context.read<ProductsCubit>().silentRefreshAllProducts(),
      context.read<CategoriesCubit>().silentRefreshAllCategories(),
    ]);

    if (!mounted) return;
    setState(() {
      _lastRefreshTime = DateTime.now();
      _isRefreshing = false;
    });

    final newState = context.read<OrdersCubit>().state;
    if (newState is OrdersLoaded) {
      final newCount = newState.orders.totalCount;
      if (newCount > _previousOrdersCount && _previousOrdersCount > 0) {
        _showNewOrderNotification(newCount - _previousOrdersCount);
      }
    }
  }

  void _showNewOrderNotification(int count) {
    final l10n = context.l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                count == 1
                    ? l10n.singleNewOrderArrived
                    : l10n.multipleNewOrdersArrived(count),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final branchFilter = context.watch<BranchSelectionCubit>().state;
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;
    final isTablet = width >= 700 && width < 1100;

    return DashboardScaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(isTablet || isDesktop ? 20 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeBanner(context, isDesktop),
              const SizedBox(height: 12),
              _buildAutoRefreshIndicator(context),
              const SizedBox(height: 20),
              _StatsGrid(width: width, branchFilter: branchFilter),
              const SizedBox(height: 20),
              _buildChartsRow(width, branchFilter),
              const SizedBox(height: 20),
              _buildBottomRow(width, branchFilter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAutoRefreshIndicator(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _PulsingDot(isActive: _isRefreshing),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _isRefreshing
                  ? l10n.autoRefreshingLabel
                  : l10n.autoRefreshEnabledLabel,
              style: TextStyle(
                color: _isRefreshing
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: 12,
                fontWeight:
                    _isRefreshing ? FontWeight.bold : FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.everySeconds(refreshInterval.inSeconds),
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
          const Spacer(),
          Text(
            l10n.lastUpdateLabel(_formatTime(_lastRefreshTime)),
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () async {
              await onRefresh();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.updatedSuccessfully),
                    backgroundColor: AppColors.success,
                    duration: const Duration(seconds: 1),
                  ),
                );
              }
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child:
                  const Icon(Icons.refresh, color: AppColors.primary, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    final s = dt.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  List<OrderEntity> _applyBranchFilter(
    List<OrderEntity> orders,
    BranchSelectionState branchFilter,
  ) {
    return orders
        .where(
          (order) => BranchFilterHelper.matchesOrder(
            order,
            selectedBranchId: branchFilter.selectedBranchId,
            selectedBranchName: branchFilter.selectedBranchName,
          ),
        )
        .toList();
  }

  Widget _buildWelcomeBanner(BuildContext context, bool isDesktop) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final dateStr = _formatDate(now);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.dashboard, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.dashboardPageTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  l10n.dashboardWelcomeSubtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop)
            Text(
              dateStr,
              style: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.8),
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChartsRow(double width, BranchSelectionState branchFilter) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (prev, current) {
        if (current is OrdersLoading && prev is OrdersLoaded) return false;
        return true;
      },
      builder: (context, state) {
        if (state is OrdersLoading) {
          return const SizedBox(
            height: 280,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }
        if (state is OrdersLoaded) {
          final filteredOrders = _applyBranchFilter(
            (state.orders.items as List).cast<OrderEntity>(),
            branchFilter,
          );
          final calc = DashboardCalculations(
            filteredOrders,
            realTotalCount: filteredOrders.length,
          );
          final isWide = width >= 900;

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: RevenueChart(calc: calc)),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: OrdersStatusChart(calc: calc)),
              ],
            );
          }
          return Column(
            children: [
              RevenueChart(calc: calc),
              const SizedBox(height: 16),
              OrdersStatusChart(calc: calc),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBottomRow(double width, BranchSelectionState branchFilter) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (prev, current) {
        if (current is OrdersLoading && prev is OrdersLoaded) return false;
        return true;
      },
      builder: (context, state) {
        if (state is! OrdersLoaded) {
          return RecentOrdersSection(branchFilter: branchFilter);
        }
        final filteredOrders = _applyBranchFilter(
          (state.orders.items as List).cast<OrderEntity>(),
          branchFilter,
        );
        final calc = DashboardCalculations(
          filteredOrders,
          realTotalCount: filteredOrders.length,
        );
        final isWide = width >= 900;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: TopProductsChart(calc: calc)),
              const SizedBox(width: 16),
              Expanded(
                child: RecentOrdersSection(branchFilter: branchFilter),
              ),
            ],
          );
        }
        return Column(
          children: [
            TopProductsChart(calc: calc),
            const SizedBox(height: 16),
            RecentOrdersSection(branchFilter: branchFilter),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    const daysAr = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    const monthsAr = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    const daysEn = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const monthsEn = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    if (isArabic) {
      return '${daysAr[date.weekday - 1]}، ${date.day} ${monthsAr[date.month - 1]} ${date.year}';
    }
    return '${daysEn[date.weekday - 1]}, ${monthsEn[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _StatsGrid extends StatelessWidget {
  final double width;
  final BranchSelectionState branchFilter;
  const _StatsGrid({required this.width, required this.branchFilter});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    int crossAxisCount;
    double childAspectRatio;
    if (width >= 1400) {
      crossAxisCount = 6;
      childAspectRatio = 1.5;
    } else if (width >= 1100) {
      crossAxisCount = 4;
      childAspectRatio = 1.45;
    } else if (width >= 700) {
      crossAxisCount = 3;
      childAspectRatio = 1.25;
    } else if (width >= 480) {
      crossAxisCount = 2;
      childAspectRatio = 1.08;
    } else {
      crossAxisCount = 1;
      childAspectRatio = 2.6;
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: childAspectRatio,
      children: [
        BlocBuilder<OrdersCubit, OrdersState>(
          buildWhen: (prev, current) {
            if (current is OrdersLoading && prev is OrdersLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            final calc = state is OrdersLoaded
                ? DashboardCalculations(
                    (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .toList(),
                    realTotalCount: (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .length,
                  )
                : null;
            return StatCard(
              title: l10n.totalOrdersLabel,
              value: '${calc?.totalOrdersCount ?? 0}',
              subtitle:
                  '${l10n.completedOrdersLabel} ${calc?.deliveredOrdersCount ?? 0}',
              icon: Icons.shopping_cart,
              color: AppColors.primary,
            );
          },
        ),
        BlocBuilder<OrdersCubit, OrdersState>(
          buildWhen: (prev, current) {
            if (current is OrdersLoading && prev is OrdersLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            final calc = state is OrdersLoaded
                ? DashboardCalculations(
                    (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .toList(),
                    realTotalCount: (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .length,
                  )
                : null;
            return StatCard(
              title: l10n.totalRevenueLabel,
              value: 'L.E ${_formatNumber(calc?.totalRevenue ?? 0)}',
              subtitle: l10n.allPeriodsLabel,
              icon: Icons.attach_money,
              color: AppColors.success,
            );
          },
        ),
        BlocBuilder<OrdersCubit, OrdersState>(
          buildWhen: (prev, current) {
            if (current is OrdersLoading && prev is OrdersLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            final calc = state is OrdersLoaded
                ? DashboardCalculations(
                    (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .toList(),
                    realTotalCount: (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .length,
                  )
                : null;
            return StatCard(
              title: l10n.weeklySalesLabel,
              value: 'L.E ${_formatNumber(calc?.weekRevenue ?? 0)}',
              subtitle: l10n.last7DaysLabel,
              icon: Icons.trending_up,
              color: AppColors.info,
            );
          },
        ),
        BlocBuilder<OrdersCubit, OrdersState>(
          buildWhen: (prev, current) {
            if (current is OrdersLoading && prev is OrdersLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            final calc = state is OrdersLoaded
                ? DashboardCalculations(
                    (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .toList(),
                    realTotalCount: (state.orders.items as List)
                        .cast<OrderEntity>()
                        .where((order) => BranchFilterHelper.matchesOrder(
                              order,
                              selectedBranchId: branchFilter.selectedBranchId,
                              selectedBranchName: branchFilter.selectedBranchName,
                            ))
                        .length,
                  )
                : null;
            return StatCard(
              title: l10n.averageOrderValueKpi,
              value: 'L.E ${_formatNumber(calc?.averageOrderValue ?? 0)}',
              subtitle: '${calc?.totalOrdersCount ?? 0} ${l10n.ordersCountWord}',
              icon: Icons.shopping_bag,
              color: AppColors.accent,
            );
          },
        ),
        BlocBuilder<ProductsCubit, ProductsState>(
          buildWhen: (prev, current) {
            if (current is ProductsLoading && prev is ProductsLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            final count = state is ProductsLoaded ? state.products.totalCount : 0;
            return StatCard(
              title: l10n.products,
              value: '$count',
              subtitle: l10n.availableProductsLabel,
              icon: Icons.cake,
              color: AppColors.warning,
            );
          },
        ),
        BlocBuilder<CategoriesCubit, CategoriesState>(
          buildWhen: (prev, current) {
            if (current is CategoriesLoading && prev is CategoriesLoaded) {
              return false;
            }
            return true;
          },
          builder: (context, state) {
            final count = state is CategoriesLoaded ? state.categories.totalCount : 0;
            return StatCard(
              title: l10n.categories,
              value: '$count',
              subtitle: l10n.categoriesCountLabel,
              icon: Icons.category,
              color: AppColors.info,
            );
          },
        ),
      ],
    );
  }

  String _formatNumber(double n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toStringAsFixed(0);
  }
}

class _PulsingDot extends StatefulWidget {
  final bool isActive;
  const _PulsingDot({required this.isActive});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final scale = widget.isActive ? 1.0 + (_controller.value * 0.5) : 1.0;
        final color = widget.isActive ? AppColors.primary : AppColors.success;
        return Container(
          width: 8 * scale,
          height: 8 * scale,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6 * _controller.value,
                      spreadRadius: 2 * _controller.value,
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
