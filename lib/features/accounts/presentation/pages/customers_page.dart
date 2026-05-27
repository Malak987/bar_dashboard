import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/usecases/orders_usecases.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit.dart';
import '../utils/customer_stats.dart';
import '../widgets/customer_details_panel.dart';
import '../widgets/customer_list_card.dart';

/// 👥 صفحة العملاء - Master-Detail Layout
///
/// بتجيب بيانات العملاء من UsersCubit وبيانات الطلبات من GetAllOrdersUseCase مباشرة.
/// كل إحصائيات العميل (عدد الطلبات، إجمالي الشراء، إلخ) محسوبة من:
///   GET /api/Orders/GetAllOrders
class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  UserEntity? _selectedUser;

  // بيانات الطلبات — متحكم فيها محلياً
  List<OrderEntity> _allOrders = [];
  bool _isOrdersLoading = false;
  String? _ordersError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersCubit>().fetchAllUsers();
      _fetchOrders();
    });
  }

  /// نجيب كل الطلبات من الـ UseCase مباشرة (من غير Cubit وسيط)
  Future<void> _fetchOrders() async {
    if (_isOrdersLoading) return;
    setState(() {
      _isOrdersLoading = true;
      _ordersError = null;
    });

    try {
      final useCase = di.sl<GetAllOrdersUseCase>();
      final result = await useCase();

      if (!mounted) return;

      result.when(
        success: (paginated) {
          setState(() {
            _allOrders = paginated.items.toList();
            _isOrdersLoading = false;
          });
        },
        failure: (f) {
          setState(() {
            _ordersError = f.message;
            _isOrdersLoading = false;
          });
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ordersError = e.toString();
        _isOrdersLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;

    return DashboardScaffold(
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, usersState) {
          // ── المستخدمين ──
          if (usersState is UsersLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (usersState is UsersFailure) {
            return _buildError(usersState.message, () {
              context.read<UsersCubit>().fetchAllUsers();
              _fetchOrders();
            });
          }

          final users = usersState is UsersLoaded
              ? usersState.users.items
              : <UserEntity>[];

          if (users.isEmpty) return _buildEmpty();

          // ── محتوى الصفحة ──
          return Stack(
            children: [
              if (isDesktop) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 380,
                      child: _buildMasterList(users),
                    ),
                    Container(width: 1, color: AppColors.border),
                    Expanded(
                      child: _selectedUser != null
                          ? CustomerDetailsPanel(
                        user: _selectedUser!,
                        allOrders: _allOrders,
                      )
                          : _buildNoSelection(),
                    ),
                  ],
                ),
              ] else ...[
                _buildMasterList(users),
              ],

              // Loading indicator للطلبات
              if (_isOrdersLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    color: AppColors.primary.withValues(alpha: 0.85),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'جاري تحميل الطلبات...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Error retry
              if (_ordersError != null && !_isOrdersLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    color: AppColors.error.withValues(alpha: 0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'خطأ: $_ordersError',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _fetchOrders,
                          child: const Text(
                            'إعادة',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  /// Master: قائمة العملاء
  Widget _buildMasterList(List<UserEntity> users) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<UsersCubit>().fetchAllUsers();
        await _fetchOrders();
      },
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          // 🔍 فلترة طلبات العميل ده من _allOrders
          final userOrders =
          _allOrders.where((o) => o.userId == user.id).toList();
          final stats = CustomerStats(userOrders);

          return CustomerListCard(
            user: user,
            ordersCount: stats.totalOrders,
            totalSpent: stats.totalSpent,
            isSelected: _selectedUser?.id == user.id,
            onTap: () {
              final w = MediaQuery.of(context).size.width;
              if (w < 1100) {
                // Mobile: push detail page مع تمرير allOrders
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Scaffold(
                      appBar: AppBar(
                        title: Text(user.name),
                        backgroundColor: AppColors.surface,
                      ),
                      body: CustomerDetailsPanel(
                        user: user,
                        allOrders: _allOrders,
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

  // ═══════════════ States ═══════════════

  Widget _buildNoSelection() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_search,
              size: 80,
              color: AppColors.textHint.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('اختر عميل من القائمة',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 4),
          const Text('لعرض التفاصيل والإحصائيات',
              style: TextStyle(color: AppColors.textHint, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline,
              size: 80,
              color: AppColors.textHint.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('لا يوجد عملاء حالياً',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {
              context.read<UsersCubit>().fetchAllUsers();
              _fetchOrders();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة تحميل'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 80, color: AppColors.error),
          const SizedBox(height: 16),
          Text(message,
              style: const TextStyle(color: AppColors.error, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}