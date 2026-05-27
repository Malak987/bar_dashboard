import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/auto_refresh_mixin.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../cubit/orders_cubit.dart';
import '../widgets/order_details_panel.dart';
import '../utils/daily_order_numbering.dart';
import '../widgets/order_list_card.dart';

/// 📋 صفحة الطلبات - Master-Detail Layout
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with WidgetsBindingObserver, AutoRefreshMixin<OrdersPage> {
  /// 🎯 نستخدم الـ ID بدل الـ entity نفسه (آمن من type errors)
  String? _selectedOrderId;
  String _searchQuery = '';
  OrderStatus? _statusFilter;
  int _previousCount = 0;
  bool _isRefreshing = false;
  DateTime _lastRefresh = DateTime.now();

  @override
  Duration get refreshInterval => const Duration(seconds: 30);

  @override
  bool get refreshOnInit => false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().fetchAllOrders();
    });
  }

  @override
  Future<void> onRefresh() async {
    if (!mounted) return;

    final current = context.read<OrdersCubit>().state;
    if (current is OrdersLoaded) {
      _previousCount = current.orders.totalCount;
    }

    setState(() => _isRefreshing = true);
    await context.read<OrdersCubit>().silentRefreshAllOrders();

    if (!mounted) return;
    setState(() {
      _isRefreshing = false;
      _lastRefresh = DateTime.now();
    });

    final newState = context.read<OrdersCubit>().state;
    if (newState is OrdersLoaded) {
      final diff = newState.orders.totalCount - _previousCount;
      if (diff > 0 && _previousCount > 0) {
        _showNewOrderNotification(diff);
      }
    }
  }

  void _showNewOrderNotification(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                count == 1
                    ? '🎉 طلب جديد وصل!'
                    : '🎉 $count طلبات جديدة وصلت!',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'عرض',
          textColor: Colors.white,
          onPressed: () {
            final state = context.read<OrdersCubit>().state;
            if (state is OrdersLoaded && state.orders.items.isNotEmpty) {
              setState(() => _selectedOrderId = state.orders.items.first.id);
            }
          },
        ),
      ),
    );
  }

  /// 🎯 الفلترة بدون cast - بنرجع List<dynamic> ونستخدمها كـ generic
  List<OrderEntity> _filterOrders(List<dynamic> orders) {
    // نحول List<dynamic> لـ List<OrderEntity> (آمن لأن كل الـ Models بترث من Entity)
    var list = orders.cast<OrderEntity>();

    if (_statusFilter != null) {
      list = list
          .where((o) => OrderStatus.fromValue(o.status) == _statusFilter)
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((o) {
        return o.id.toLowerCase().contains(q) ||
            o.userName.toLowerCase().contains(q) ||
            o.address.toLowerCase().contains(q);
      }).toList();
    }

    list.sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
    return list;
  }

  /// 🎯 helper آمن للحصول على order من ID
  OrderEntity? _findOrderById(List<OrderEntity> orders, String? id) {
    if (id == null) return null;
    for (final o in orders) {
      if (o.id == id) return o;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;

    return DashboardScaffold(
      pageTitle: 'الطلبات',
      pageSubtitle: 'إدارة طلبات العملاء',
      pageIcon: Icons.shopping_cart,
      headerAction: BlocBuilder<OrdersCubit, OrdersState>(
        buildWhen: (_, c) => c is OrdersLoaded,
        builder: (context, state) {
          int total = 0;
          int pending = 0;
          if (state is OrdersLoaded) {
            total = state.orders.totalCount;
            pending = state.orders.items
                .where((o) => o.status == 0 || o.status == 1)
                .length;
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _countBadge('$total إجمالي', AppColors.primary),
              const SizedBox(width: 6),
              if (pending > 0)
                _countBadge('$pending قيد التنفيذ', AppColors.warning),
              const SizedBox(width: 12),
              _buildRefreshButton(),
            ],
          );
        },
      ),
      body: Column(
        children: [
          _buildFiltersBar(),
          Expanded(
            child: BlocBuilder<OrdersCubit, OrdersState>(
              buildWhen: (previous, current) {
                if (current is OrdersLoaded || current is OrdersFailure) {
                  return true;
                }
                if (current is OrdersLoading && previous is! OrdersLoaded) {
                  return true;
                }
                return false;
              },
              builder: (context, state) {
                if (state is OrdersLoading || state is OrdersInitial) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary));
                }
                if (state is OrdersFailure) {
                  return _buildError(state.message);
                }
                if (state is OrdersLoaded) {
                  final orders = _filterOrders(state.orders.items);
                  if (orders.isEmpty) {
                    return _buildEmpty();
                  }

                  // ✅ اختر أول order تلقائياً
                  if (_selectedOrderId == null && orders.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() => _selectedOrderId = orders.first.id);
                      }
                    });
                  }

                  // 🔢 نُنشئ الترقيم اليومي من كل الأوردرات (مش المفلترة)
                  // عشان الأرقام تكون ثابتة بصرف النظر عن الفلتر الحالي
                  final numbering = DailyOrderNumbering(
                      (state.orders.items as List).cast<OrderEntity>());

                  if (isWide) {
                    return _buildMasterDetail(orders, numbering);
                  } else {
                    return _buildMobileList(orders, numbering);
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _isRefreshing ? AppColors.primary : AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            _isRefreshing ? 'تحديث...' : 'مباشر',
            style: TextStyle(
                color: _isRefreshing
                    ? AppColors.primary
                    : AppColors.success,
                fontSize: 11,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRefresh,
            borderRadius: BorderRadius.circular(4),
            child: const Icon(Icons.refresh,
                color: AppColors.primary, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _countBadge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(text,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11)),
  );

  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'ابحث برقم الطلب، اسم العميل، العنوان...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButton<OrderStatus?>(
              value: _statusFilter,
              hint: const Text('كل الحالات',
                  style: TextStyle(color: AppColors.textSecondary)),
              underline: const SizedBox.shrink(),
              dropdownColor: AppColors.surfaceLight,
              style: const TextStyle(color: AppColors.textPrimary),
              icon: const Icon(Icons.filter_list,
                  color: AppColors.textSecondary),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('كل الحالات')),
                ...OrderStatus.values.map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.arabicName),
                )),
              ],
              onChanged: (v) => setState(() => _statusFilter = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterDetail(
      List<OrderEntity> orders, DailyOrderNumbering numbering) {
    final selectedOrder = _findOrderById(orders, _selectedOrderId);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 320,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: AppColors.border)),
            ),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (_, i) {
                final o = orders[i];
                return OrderListCard(
                  order: o,
                  dailyNumber: numbering.getNumberFor(o.id),
                  isSelected: _selectedOrderId == o.id,
                  onTap: () => setState(() => _selectedOrderId = o.id),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: selectedOrder == null
              ? _buildNoSelection()
              : OrderDetailsPanel(
            order: selectedOrder,
            dailyNumber: numbering.getNumberFor(selectedOrder.id),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileList(
      List<OrderEntity> orders, DailyOrderNumbering numbering) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (_, i) {
        final o = orders[i];
        final orderNumber = numbering.getNumberFor(o.id);
        return OrderListCard(
          order: o,
          dailyNumber: orderNumber,
          isSelected: false,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<OrdersCubit>(),
                  child: Scaffold(
                    backgroundColor: AppColors.background,
                    appBar: AppBar(
                      title: Text('طلب #\${orderNumber.toString().padLeft(3, "0")}'),
                      backgroundColor: AppColors.surface,
                    ),
                    body: OrderDetailsPanel(
                      order: o,
                      dailyNumber: orderNumber,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNoSelection() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long,
              size: 80,
              color: AppColors.textHint.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text('اختر طلباً لعرض تفاصيله',
              style: TextStyle(
                  color: AppColors.textSecondary, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 80, color: AppColors.textHint),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isNotEmpty || _statusFilter != null
                ? 'لا توجد نتائج مطابقة'
                : 'لا توجد طلبات بعد',
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline,
              size: 60, color: AppColors.error),
          const SizedBox(height: 12),
          Text(msg, style: const TextStyle(color: AppColors.error)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => context.read<OrdersCubit>().fetchAllOrders(),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
