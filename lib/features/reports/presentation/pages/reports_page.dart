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
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
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

  Map<String, int> _customerOrdersMap(List<OrderEntity> orders) {
    final result = <String, int>{};
    for (final order in orders) {
      result.update(order.userId, (value) => value + 1, ifAbsent: () => 1);
    }
    return result;
  }

  Map<String, double> _customerSpendMap(List<OrderEntity> orders) {
    final result = <String, double>{};
    for (final order in orders) {
      result.update(order.userId, (value) => value + order.totalAmount,
          ifAbsent: () => order.totalAmount);
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
      pageTitle: l10n.reports,
      pageSubtitle: l10n.reportsPageSubtitle,
      pageIcon: Icons.assessment,
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
          final orders = _applyBranchFilter(allOrders, branchFilter);
          final calc = DashboardCalculations(orders, realTotalCount: orders.length);
          final users = usersState is UsersLoaded ? usersState.users.items : <UserEntity>[];
          final branches = branchesState is BranchesLoaded
              ? branchesState.branches.items
              : <BranchEntity>[];
          final ordersMap = _customerOrdersMap(orders);
          final spendMap = _customerSpendMap(orders);
          final repeatCustomers = ordersMap.values.where((value) => value >= 2).length;
          final activeCustomers = users.where((user) => ordersMap.containsKey(user.id)).length;
          final missingBranchData = !branchFilter.isAllBranches &&
              !BranchFilterHelper.listHasAnyBranchData(allOrders);

          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                context.read<OrdersCubit>().silentRefreshAllOrders(),
                context.read<UsersCubit>().silentRefreshAllUsers(),
                context.read<BranchesCubit>().silentRefreshAllBranches(),
              ]);
            },
            color: AppColors.primary,
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _buildExecutiveHeader(context, branchFilter, missingBranchData),
                const SizedBox(height: 16),
                _buildExecutiveSummary(context, calc, activeCustomers, repeatCustomers),
                const SizedBox(height: 16),
                _buildFinancialReport(context, calc),
                const SizedBox(height: 16),
                _buildCustomersReport(context, users, ordersMap, spendMap),
                const SizedBox(height: 16),
                _buildBranchesReport(context, branches, orders, missingBranchData),
                const SizedBox(height: 16),
                _buildRecommendations(context, calc, activeCustomers, branches.length),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExecutiveHeader(
    BuildContext context,
    BranchSelectionState branchFilter,
    bool missingBranchData,
  ) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branchFilter.isAllBranches
                ? l10n.reportExecutiveHeaderAll
                : l10n.reportExecutiveHeaderBranch(branchFilter.selectedBranchName),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.reportExecutiveDescription,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          if (missingBranchData) ...[
            const SizedBox(height: 10),
            Text(
              l10n.reportMissingBranchData,
              style: const TextStyle(color: AppColors.warning, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExecutiveSummary(
    BuildContext context,
    DashboardCalculations calc,
    int activeCustomers,
    int repeatCustomers,
  ) {
    final l10n = context.l10n;
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 650
                ? 2
                : 1;
        final items = [
          _ReportMetric(l10n.totalOrdersLabel, '${calc.totalOrdersCount}', Icons.shopping_cart, AppColors.primary),
          _ReportMetric(l10n.totalRevenueKpi, 'L.E ${calc.totalRevenue.toStringAsFixed(0)}', Icons.payments, AppColors.success),
          _ReportMetric(l10n.activeCustomersLabel, '$activeCustomers', Icons.people, AppColors.info),
          _ReportMetric(l10n.repeatCustomersLabel, '$repeatCustomers', Icons.replay, AppColors.warning),
        ];
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 1 ? 3.4 : 1.8,
          ),
          itemBuilder: (_, index) => _metricCard(items[index]),
        );
      },
    );
  }

  Widget _buildFinancialReport(BuildContext context, DashboardCalculations calc) {
    final l10n = context.l10n;
    return _sectionCard(
      title: l10n.financialReportTitle,
      child: Column(
        children: [
          _reportRow(l10n.todayRevenueLabel, 'L.E ${calc.todayRevenue.toStringAsFixed(0)}'),
          _reportRow(l10n.weekRevenueLabel, 'L.E ${calc.weekRevenue.toStringAsFixed(0)}'),
          _reportRow(l10n.monthRevenueLabel, 'L.E ${calc.monthRevenue.toStringAsFixed(0)}'),
          _reportRow(l10n.averageOrderValueLabel, 'L.E ${calc.averageOrderValue.toStringAsFixed(0)}'),
          _reportRow(l10n.completedOrdersLabel, '${calc.deliveredOrdersCount}'),
          _reportRow(l10n.cancelledOrdersCountLabel, '${calc.cancelledOrdersCount}'),
        ],
      ),
    );
  }

  Widget _buildCustomersReport(
    BuildContext context,
    List<UserEntity> users,
    Map<String, int> ordersMap,
    Map<String, double> spendMap,
  ) {
    final l10n = context.l10n;
    final topCustomers = users
        .where((user) => spendMap.containsKey(user.id))
        .map((user) => _CustomerReportRow(
              name: user.name,
              ordersCount: ordersMap[user.id] ?? 0,
              totalSpent: spendMap[user.id] ?? 0,
            ))
        .toList()
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));

    return _sectionCard(
      title: l10n.customersReportTitle,
      child: topCustomers.isEmpty
          ? Text(l10n.noEnoughCustomerData, style: const TextStyle(color: AppColors.textHint))
          : Column(
              children: topCustomers.take(8).map((customer) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  title: Text(customer.name, style: const TextStyle(color: AppColors.textPrimary)),
                  subtitle: Text(
                    '${customer.ordersCount} ${l10n.ordersCountWord}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: Text(
                    'L.E ${customer.totalSpent.toStringAsFixed(0)}',
                    style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildBranchesReport(
    BuildContext context,
    List<BranchEntity> branches,
    List<OrderEntity> orders,
    bool missingBranchData,
  ) {
    final l10n = context.l10n;
    return _sectionCard(
      title: l10n.branchesReportTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.branchesOverview(
              branches.length,
              branches.where((branch) => !branch.isArchived).length,
              branches.where((branch) => branch.isArchived).length,
            ),
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          if (missingBranchData)
            Text(
              l10n.branchDistributionUnavailable,
              style: const TextStyle(color: AppColors.warning),
            )
          else
            ...branches.map((branch) {
              final count = orders.where((order) {
                final branchId = order.branchId?.trim().toLowerCase();
                final branchName = order.branchName?.trim().toLowerCase();
                return branch.id.trim().toLowerCase() == branchId ||
                    branch.nameAr.trim().toLowerCase() == branchName ||
                    branch.nameEn.trim().toLowerCase() == branchName;
              }).length;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  branch.isArchived ? Icons.lock_clock : Icons.store,
                  color: branch.isArchived ? AppColors.error : AppColors.success,
                ),
                title: Text(branch.nameAr, style: const TextStyle(color: AppColors.textPrimary)),
                subtitle: Text(branch.phone, style: const TextStyle(color: AppColors.textSecondary)),
                trailing: Text(
                  '$count ${l10n.ordersCountWord}',
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildRecommendations(
    BuildContext context,
    DashboardCalculations calc,
    int activeCustomers,
    int branchesCount,
  ) {
    final l10n = context.l10n;
    final recommendations = <String>[
      if (calc.cancelledOrdersCount > 0)
        l10n.recommendationCancelledOrders(calc.cancelledOrdersCount),
      if (activeCustomers < 5) l10n.recommendationLowActiveCustomers,
      if (branchesCount > 0 && calc.totalOrdersCount > 0)
        l10n.recommendationBranchBalance,
      if (calc.averageOrderValue > 0)
        l10n.recommendationAverageOrder(calc.averageOrderValue.toStringAsFixed(0)),
    ];

    return _sectionCard(
      title: l10n.recommendationsTitle,
      child: recommendations.isEmpty
          ? Text(l10n.noCriticalRecommendations, style: const TextStyle(color: AppColors.textHint))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recommendations.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(Icons.check_circle, color: AppColors.success, size: 16),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
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
          Text(title,
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _metricCard(_ReportMetric metric) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: metric.color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: metric.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(metric.icon, color: metric.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(metric.title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(metric.value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary))),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
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

class _ReportMetric {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _ReportMetric(this.title, this.value, this.icon, this.color);
}

class _CustomerReportRow {
  final String name;
  final int ordersCount;
  final double totalSpent;

  const _CustomerReportRow({
    required this.name,
    required this.ordersCount,
    required this.totalSpent,
  });
}
