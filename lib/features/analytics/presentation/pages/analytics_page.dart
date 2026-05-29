import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/branch_selection/branch_selection_cubit.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/branch_filter_helper.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../accounts/domain/entities/user_entity.dart';
import '../../../accounts/presentation/cubit/users_cubit.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../../../branches/presentation/cubit/branches_cubit.dart';
import '../../../dashboard/presentation/utils/dashboard_calculations.dart';
import '../../../dashboard/presentation/widgets/orders_status_chart.dart';
import '../../../dashboard/presentation/widgets/revenue_chart.dart';
import '../../../dashboard/presentation/widgets/top_products_chart.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ordersCubit = context.read<OrdersCubit>();
      final usersCubit = context.read<UsersCubit>();
      final branchesCubit = context.read<BranchesCubit>();

      if (ordersCubit.state is OrdersInitial) {
        ordersCubit.fetchAllOrders();
      } else {
        ordersCubit.silentRefreshAllOrders();
      }

      if (usersCubit.state is UsersInitial) {
        usersCubit.fetchAllUsers();
      } else {
        usersCubit.silentRefreshAllUsers();
      }

      if (branchesCubit.state is BranchesInitial) {
        branchesCubit.fetchAllBranches();
      } else {
        branchesCubit.silentRefreshAllBranches();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Map<String, double> _customerSpendMap(List<OrderEntity> orders) {
    final spend = <String, double>{};
    for (final order in orders) {
      spend.update(
        order.userId,
        (value) => value + order.totalAmount,
        ifAbsent: () => order.totalAmount,
      );
    }
    return spend;
  }

  Map<String, int> _customerOrdersMap(List<OrderEntity> orders) {
    final counts = <String, int>{};
    for (final order in orders) {
      counts.update(order.userId, (value) => value + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  Map<String, int> _ordersByBranch(List<OrderEntity> orders, List<BranchEntity> branches) {
    final result = <String, int>{};
    for (final branch in branches) {
      result[branch.nameAr] = 0;
    }

    for (final order in orders) {
      final branchId = order.branchId?.trim().toLowerCase();
      final branchName = order.branchName?.trim().toLowerCase();
      for (final branch in branches) {
        final candidateId = branch.id.trim().toLowerCase();
        final candidateAr = branch.nameAr.trim().toLowerCase();
        final candidateEn = branch.nameEn.trim().toLowerCase();
        final matched = (branchId != null && branchId.isNotEmpty && branchId == candidateId) ||
            (branchName != null && branchName.isNotEmpty &&
                (branchName == candidateAr ||
                    branchName == candidateEn ||
                    branchName.contains(candidateAr) ||
                    branchName.contains(candidateEn) ||
                    candidateAr.contains(branchName) ||
                    candidateEn.contains(branchName)));
        if (matched) {
          result.update(branch.nameAr, (value) => value + 1, ifAbsent: () => 1);
          break;
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final branchFilter = context.watch<BranchSelectionCubit>().state;
    final usersState = context.watch<UsersCubit>().state;
    final branchesState = context.watch<BranchesCubit>().state;

    return DashboardScaffold(
      pageTitle: l10n.analytics,
      pageSubtitle: l10n.analyticsPageSubtitle,
      pageIcon: Icons.analytics,
      body: BlocBuilder<OrdersCubit, OrdersState>(
        buildWhen: (previous, current) {
          if (current is OrdersLoading && previous is OrdersLoaded) return false;
          return current is OrdersInitial ||
              current is OrdersLoading ||
              current is OrdersLoaded ||
              current is OrdersFailure;
        },
        builder: (context, ordersState) {
          if (ordersState is OrdersInitial || ordersState is OrdersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (ordersState is OrdersFailure) {
            return _buildError(context, ordersState.message);
          }

          if (ordersState is! OrdersLoaded) {
            return const SizedBox.shrink();
          }

          final allOrders = ordersState.orders.items.cast<OrderEntity>();
          final filteredOrders = _applyBranchFilter(allOrders, branchFilter);
          final calc = DashboardCalculations(
            filteredOrders,
            realTotalCount: filteredOrders.length,
          );
          final users = usersState is UsersLoaded ? usersState.users.items : <UserEntity>[];
          final branches = branchesState is BranchesLoaded
              ? branchesState.branches.items
              : <BranchEntity>[];
          final missingBranchData = !branchFilter.isAllBranches &&
              !BranchFilterHelper.listHasAnyBranchData(allOrders);

          return Column(
            children: [
              _buildScopeBanner(context, branchFilter, missingBranchData),
              Material(
                color: AppColors.surface,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: AppColors.primary,
                  tabs: [
                    Tab(text: l10n.financialTab),
                    Tab(text: l10n.customersTab),
                    Tab(text: l10n.employeesTab),
                    Tab(text: l10n.salesTab),
                    Tab(text: l10n.branchesTab),
                    Tab(text: l10n.ordersTab),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFinancialTab(context, calc),
                    _buildCustomersTab(context, users, filteredOrders),
                    _buildEmployeesTab(context, filteredOrders, branches),
                    _buildSalesTab(context, calc),
                    _buildBranchesTab(context, filteredOrders, branches, missingBranchData),
                    _buildOrdersTab(context, calc),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScopeBanner(
    BuildContext context,
    BranchSelectionState branchFilter,
    bool missingBranchData,
  ) {
    final l10n = context.l10n;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branchFilter.isAllBranches
                ? l10n.analyticsScopeAll
                : l10n.analyticsScopeBranch(branchFilter.selectedBranchName),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.analyticsScopeDescription,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          if (missingBranchData) ...[
            const SizedBox(height: 10),
            Text(
              l10n.analyticsMissingBranchData,
              style: const TextStyle(color: AppColors.warning, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFinancialTab(BuildContext context, DashboardCalculations calc) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        _kpiGrid([
          _KpiData(l10n.totalRevenueKpi, 'L.E ${calc.totalRevenue.toStringAsFixed(0)}', Icons.payments, AppColors.success),
          _KpiData(l10n.todayRevenueKpi, 'L.E ${calc.todayRevenue.toStringAsFixed(0)}', Icons.today, AppColors.info),
          _KpiData(l10n.weekRevenueKpi, 'L.E ${calc.weekRevenue.toStringAsFixed(0)}', Icons.date_range, AppColors.primary),
          _KpiData(l10n.monthRevenueKpi, 'L.E ${calc.monthRevenue.toStringAsFixed(0)}', Icons.calendar_month, AppColors.accent),
          _KpiData(l10n.averageOrderValueLabel, 'L.E ${calc.averageOrderValue.toStringAsFixed(0)}', Icons.shopping_bag, AppColors.warning),
          _KpiData(l10n.orderCountKpi, '${calc.totalOrdersCount}', Icons.receipt_long, AppColors.primaryLight),
        ]),
        const SizedBox(height: 16),
        RevenueChart(calc: calc),
      ],
    );
  }

  Widget _buildCustomersTab(BuildContext context, List<UserEntity> users, List<OrderEntity> orders) {
    final l10n = context.l10n;
    final spendMap = _customerSpendMap(orders);
    final ordersMap = _customerOrdersMap(orders);
    final activeCustomers = users.where((user) => ordersMap.containsKey(user.id)).length;
    final repeatCustomers = ordersMap.values.where((count) => count >= 2).length;
    final vipCustomers = spendMap.values.where((value) => value >= 1000).length;

    final topSpenders = users
        .where((user) => spendMap.containsKey(user.id))
        .map((user) => MapEntry(user.name, spendMap[user.id]!))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _kpiGrid([
          _KpiData(l10n.totalCustomersKpi, '${users.length}', Icons.people, AppColors.primary),
          _KpiData(l10n.activeCustomersKpi, '$activeCustomers', Icons.person_search, AppColors.success),
          _KpiData(l10n.repeatCustomersKpi, '$repeatCustomers', Icons.replay, AppColors.info),
          _KpiData(l10n.vipCustomersKpi, '$vipCustomers', Icons.workspace_premium, AppColors.warning),
        ]),
        const SizedBox(height: 16),
        _sectionCard(
          title: l10n.topSpendingCustomersTitle,
          child: topSpenders.isEmpty
              ? Text(l10n.noEnoughCustomerData, style: const TextStyle(color: AppColors.textHint))
              : Column(
                  children: topSpenders.take(8).map((entry) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                        child: const Icon(Icons.person, color: AppColors.primary),
                      ),
                      title: Text(entry.key, style: const TextStyle(color: AppColors.textPrimary)),
                      trailing: Text(
                        'L.E ${entry.value.toStringAsFixed(0)}',
                        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildEmployeesTab(BuildContext context, List<OrderEntity> orders, List<BranchEntity> branches) {
    final l10n = context.l10n;
    final openBranches = branches.where((branch) => !branch.isArchived).length;
    final todayOrders = DashboardCalculations(orders).todayOrdersCount;
    final inProgress = DashboardCalculations(orders).inProgressOrdersCount;
    final estimatedCashiers = math.max(1, (todayOrders / 12).ceil());
    final estimatedKitchen = math.max(1, (inProgress / 8).ceil());
    final estimatedDelivery = math.max(1, (orders.where((o) => o.status == 3).length / 6).ceil());
    final loadPerBranch = openBranches == 0 ? 0 : (orders.length / openBranches).ceil();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionCard(
          title: l10n.employeesAnalyticsEstimatedTitle,
          child: Text(
            l10n.employeesEstimatedSubtitle,
            style: const TextStyle(color: AppColors.warning, fontSize: 12),
          ),
        ),
        const SizedBox(height: 16),
        _kpiGrid([
          _KpiData(l10n.neededCashiers, '$estimatedCashiers', Icons.point_of_sale, AppColors.primary),
          _KpiData(l10n.neededKitchen, '$estimatedKitchen', Icons.restaurant, AppColors.accent),
          _KpiData(l10n.neededDelivery, '$estimatedDelivery', Icons.delivery_dining, AppColors.success),
          _KpiData(l10n.loadPerBranch, '$loadPerBranch', Icons.speed, AppColors.warning),
        ]),
      ],
    );
  }

  Widget _buildSalesTab(BuildContext context, DashboardCalculations calc) {
    final l10n = context.l10n;
    final topProducts = calc.getTopProducts(limit: 10);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _kpiGrid([
          _KpiData(l10n.totalOrdersLabel, '${calc.totalOrdersCount}', Icons.shopping_cart, AppColors.primary),
          _KpiData(l10n.completedOrdersLabel, '${calc.deliveredOrdersCount}', Icons.check_circle, AppColors.success),
          _KpiData(l10n.cancelledOrdersCountLabel, '${calc.cancelledOrdersCount}', Icons.cancel, AppColors.error),
          _KpiData(l10n.averageOrderValueLabel, 'L.E ${calc.averageOrderValue.toStringAsFixed(0)}', Icons.sell, AppColors.info),
        ]),
        const SizedBox(height: 16),
        TopProductsChart(calc: calc),
        const SizedBox(height: 16),
        _sectionCard(
          title: l10n.topProductsTitle,
          child: topProducts.isEmpty
              ? Text(l10n.noDataLabel, style: const TextStyle(color: AppColors.textHint))
              : Column(
                  children: topProducts.map((entry) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.local_fire_department, color: AppColors.accent),
                      title: Text(entry.key, style: const TextStyle(color: AppColors.textPrimary)),
                      trailing: Text(
                        '${entry.value} ${l10n.requestWord}',
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildBranchesTab(
    BuildContext context,
    List<OrderEntity> orders,
    List<BranchEntity> branches,
    bool missingBranchData,
  ) {
    final l10n = context.l10n;
    final openBranches = branches.where((branch) => !branch.isArchived).length;
    final closedBranches = branches.where((branch) => branch.isArchived).length;
    final branchOrders = _ordersByBranch(orders, branches);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _kpiGrid([
          _KpiData(l10n.openBranchesKpi, '$openBranches', Icons.store, AppColors.success),
          _KpiData(l10n.closedBranchesKpi, '$closedBranches', Icons.store_mall_directory_outlined, AppColors.error),
          _KpiData(l10n.totalBranchesKpi, '${branches.length}', Icons.apartment, AppColors.primary),
          _KpiData(l10n.linkedOrdersToBranch, '${branchOrders.values.fold<int>(0, (sum, item) => sum + item)}', Icons.link, AppColors.info),
        ]),
        const SizedBox(height: 16),
        if (missingBranchData)
          _sectionCard(
            title: l10n.branchLinkWarningTitle,
            child: Text(
              l10n.analyticsMissingBranchData,
              style: const TextStyle(color: AppColors.warning),
            ),
          )
        else
          _sectionCard(
            title: l10n.branchDistributionTitle,
            child: Column(
              children: branches.map((branch) {
                final count = branchOrders[branch.nameAr] ?? 0;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    branch.isArchived ? Icons.lock_clock : Icons.store,
                    color: branch.isArchived ? AppColors.error : AppColors.success,
                  ),
                  title: Text(branch.nameAr, style: const TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text(branch.addressAr, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                  trailing: Text(
                    '$count ${l10n.ordersCountWord}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildOrdersTab(BuildContext context, DashboardCalculations calc) {
    final l10n = context.l10n;
    final deliveredRate = calc.totalOrdersCount == 0
        ? 0.0
        : (calc.deliveredOrdersCount / calc.totalOrdersCount) * 100;
    final cancelledRate = calc.totalOrdersCount == 0
        ? 0.0
        : (calc.cancelledOrdersCount / calc.totalOrdersCount) * 100;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _kpiGrid([
          _KpiData(l10n.totalOrdersLabel, '${calc.totalOrdersCount}', Icons.receipt_long, AppColors.primary),
          _KpiData(l10n.inProgressOrdersKpi, '${calc.inProgressOrdersCount}', Icons.timelapse, AppColors.warning),
          _KpiData(l10n.completionRateKpi, '${deliveredRate.toStringAsFixed(0)}%', Icons.verified, AppColors.success),
          _KpiData(l10n.cancellationRateKpi, '${cancelledRate.toStringAsFixed(0)}%', Icons.block, AppColors.error),
        ]),
        const SizedBox(height: 16),
        OrdersStatusChart(calc: calc),
      ],
    );
  }

  Widget _kpiGrid(List<_KpiData> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 700
                ? 2
                : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 1 ? 3.3 : 1.7,
          ),
          itemBuilder: (_, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: item.color.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(item.value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
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
          Text(title, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 64),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: AppColors.error)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => context.read<OrdersCubit>().fetchAllOrders(),
            icon: const Icon(Icons.refresh),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    );
  }
}

class _KpiData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiData(this.title, this.value, this.icon, this.color);
}
