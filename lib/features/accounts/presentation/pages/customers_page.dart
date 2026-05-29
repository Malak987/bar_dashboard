import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/branch_selection/branch_selection_cubit.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/branch_filter_helper.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit.dart';
import '../utils/customer_stats.dart';
import '../widgets/customer_details_panel.dart';
import '../widgets/customer_list_card.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  UserEntity? _selectedUser;

  List<UserEntity> _cachedUsers = const [];
  List<OrderEntity> _cachedOrders = const [];

  bool _isInitialUsersLoading = true;
  bool _isInitialOrdersLoading = true;
  String? _usersError;
  String? _ordersError;

  String _normalizeId(String id) => id.trim().toLowerCase();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrapUsers();
      _bootstrapOrders();
    });
  }

  void _bootstrapUsers() {
    final cubit = context.read<UsersCubit>();
    final current = cubit.state;

    if (current is UsersLoaded) {
      setState(() {
        _cachedUsers = current.users.items.toList();
        _isInitialUsersLoading = false;
        _usersError = null;
      });
      cubit.silentRefreshAllUsers();
    } else {
      cubit.fetchAllUsers();
    }
  }

  void _bootstrapOrders() {
    final cubit = context.read<OrdersCubit>();
    final current = cubit.state;

    if (current is OrdersLoaded) {
      setState(() {
        _cachedOrders = (current.orders.items as List).cast<OrderEntity>();
        _isInitialOrdersLoading = false;
        _ordersError = null;
      });
      cubit.silentRefreshAllOrders();
    } else {
      cubit.fetchAllOrders();
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([
      context.read<UsersCubit>().silentRefreshAllUsers(),
      context.read<OrdersCubit>().silentRefreshAllOrders(),
    ]);
  }

  List<OrderEntity> _applyBranchFilter(BranchSelectionState branchFilter) {
    return _cachedOrders
        .where(
          (order) => BranchFilterHelper.matchesOrder(
            order,
            selectedBranchId: branchFilter.selectedBranchId,
            selectedBranchName: branchFilter.selectedBranchName,
          ),
        )
        .toList();
  }

  Map<String, List<OrderEntity>> _ordersByUserId(List<OrderEntity> orders) {
    final map = <String, List<OrderEntity>>{};
    for (final order in orders) {
      final normalizedId = _normalizeId(order.userId);
      map.putIfAbsent(normalizedId, () => <OrderEntity>[]).add(order);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final branchFilter = context.watch<BranchSelectionCubit>().state;
    final visibleOrders = _applyBranchFilter(branchFilter);
    final ordersByUserId = _ordersByUserId(visibleOrders);
    final visibleUsers = branchFilter.isAllBranches
        ? _cachedUsers
        : _cachedUsers
            .where((user) => ordersByUserId.containsKey(_normalizeId(user.id)))
            .toList();
    final hasSelectedUserOrders = _selectedUser != null &&
        (branchFilter.isAllBranches ||
            visibleOrders.any(
              (o) => _normalizeId(o.userId) == _normalizeId(_selectedUser!.id),
            ));
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;

    return DashboardScaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<UsersCubit, UsersState>(
            listener: (context, state) {
              if (state is UsersLoaded) {
                setState(() {
                  _cachedUsers = state.users.items.toList();
                  _isInitialUsersLoading = false;
                  _usersError = null;
                });
              } else if (state is UsersFailure) {
                setState(() {
                  _isInitialUsersLoading = false;
                  _usersError = state.message;
                });
              }
            },
          ),
          BlocListener<OrdersCubit, OrdersState>(
            listener: (context, state) {
              if (state is OrdersLoaded) {
                setState(() {
                  _cachedOrders = (state.orders.items as List).cast<OrderEntity>();
                  _isInitialOrdersLoading = false;
                  _ordersError = null;
                });
              } else if (state is OrdersFailure) {
                setState(() {
                  _isInitialOrdersLoading = false;
                  _ordersError = state.message;
                });
              }
            },
          ),
        ],
        child: _buildBody(
          visibleUsers: visibleUsers,
          visibleOrders: visibleOrders,
          ordersByUserId: ordersByUserId,
          hasSelectedUserOrders: hasSelectedUserOrders,
          branchFilter: branchFilter,
          isDesktop: isDesktop,
        ),
      ),
    );
  }

  Widget _buildBody({
    required List<UserEntity> visibleUsers,
    required List<OrderEntity> visibleOrders,
    required Map<String, List<OrderEntity>> ordersByUserId,
    required bool hasSelectedUserOrders,
    required BranchSelectionState branchFilter,
    required bool isDesktop,
  }) {
    if (_isInitialUsersLoading && _cachedUsers.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_usersError != null && _cachedUsers.isEmpty) {
      return _buildError(_usersError!, () {
        context.read<UsersCubit>().fetchAllUsers();
        context.read<OrdersCubit>().fetchAllOrders();
      });
    }

    if (_cachedUsers.isEmpty) {
      return _buildEmptyUsers();
    }

    return Stack(
      children: [
        if (isDesktop)
          Row(
            children: [
              SizedBox(
                width: 380,
                child: _buildMasterList(
                  visibleUsers: visibleUsers,
                  visibleOrders: visibleOrders,
                  ordersByUserId: ordersByUserId,
                  branchFilter: branchFilter,
                ),
              ),
              Container(width: 1, color: AppColors.border),
              Expanded(
                child: hasSelectedUserOrders
                    ? CustomerDetailsPanel(
                        user: _selectedUser!,
                        allOrders: visibleOrders,
                      )
                    : _buildNoSelection(branchFilter, visibleUsers),
              ),
            ],
          )
        else
          _buildMasterList(
            visibleUsers: visibleUsers,
            visibleOrders: visibleOrders,
            ordersByUserId: ordersByUserId,
            branchFilter: branchFilter,
          ),
        if (_isInitialOrdersLoading && _cachedOrders.isEmpty)
          Positioned.fill(
            child: Container(
              color: AppColors.background.withValues(alpha: 0.75),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
        if (_ordersError != null && _cachedOrders.isEmpty)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _buildInlineError(_ordersError!, () {
              context.read<OrdersCubit>().fetchAllOrders();
            }),
          )
        else if (_ordersError != null)
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: _buildInlineError(_ordersError!, () {
              context.read<OrdersCubit>().silentRefreshAllOrders();
            }),
          ),
      ],
    );
  }

  Widget _buildMasterList({
    required List<UserEntity> visibleUsers,
    required List<OrderEntity> visibleOrders,
    required Map<String, List<OrderEntity>> ordersByUserId,
    required BranchSelectionState branchFilter,
  }) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: _refreshAll,
      color: AppColors.primary,
      child: visibleUsers.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                const SizedBox(height: 120),
                Icon(
                  Icons.people_outline,
                  size: 72,
                  color: AppColors.textHint.withValues(alpha: 0.35),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    branchFilter.isAllBranches
                        ? l10n.noCustomersYet
                        : l10n.noCustomersForSelectedBranch,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: visibleUsers.length,
              itemBuilder: (context, index) {
                final user = visibleUsers[index];
                final userOrders =
                    ordersByUserId[_normalizeId(user.id)] ?? const <OrderEntity>[];
                final stats = CustomerStats(userOrders);

                return CustomerListCard(
                  user: user,
                  ordersCount: stats.totalOrders,
                  totalSpent: stats.totalSpent,
                  isSelected: _selectedUser?.id == user.id,
                  onTap: () {
                    final width = MediaQuery.of(context).size.width;
                    if (width < 1100) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(
                              title: Text(user.name),
                              backgroundColor: AppColors.surface,
                            ),
                            body: CustomerDetailsPanel(
                              user: user,
                              allOrders: visibleOrders,
                            ),
                          ),
                        ),
                      );
                    } else {
                      setState(() => _selectedUser = user);
                    }
                  },
                );
              },
            ),
    );
  }

  Widget _buildNoSelection(
    BranchSelectionState branchFilter,
    List<UserEntity> visibleUsers,
  ) {
    final l10n = context.l10n;
    final message = visibleUsers.isEmpty
        ? (branchFilter.isAllBranches
            ? l10n.noCustomersYet
            : l10n.noCustomersInSelectedBranch)
        : l10n.selectCustomerFromList;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_search,
            size: 80,
            color: AppColors.textHint.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.viewDetailsAndStats,
            style: TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUsers() {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: AppColors.textHint.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noCustomersYet,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              context.read<UsersCubit>().fetchAllUsers();
              context.read<OrdersCubit>().fetchAllOrders();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.reload),
          ),
        ],
      ),
    );
  }

  Widget _buildInlineError(String message, VoidCallback onRetry) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(
              l10n.retry,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, VoidCallback onRetry) {
    final l10n = context.l10n;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: AppColors.error, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
