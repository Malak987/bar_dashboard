import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gps_helper.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';
import '../../../orders/presentation/utils/daily_order_numbering.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/users_cubit.dart';
import '../utils/customer_stats.dart';
import 'block_user_dialog.dart';

/// 👤 لوحة تفاصيل العميل - يمين Master-Detail
class CustomerDetailsPanel extends StatelessWidget {
  final UserEntity user;

  const CustomerDetailsPanel({super.key, required this.user});

  Future<void> _callPhone(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp(String number) async {
    var cleanPhone = number.replaceAll(RegExp(r'[\s\-()]'), '');
    if (cleanPhone.startsWith('0')) {
      cleanPhone = '20${cleanPhone.substring(1)}';
    }
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _blockUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlockUserDialog(
        user: user,
        onConfirm: (reason) {
          context
              .read<UsersCubit>()
              .blockUser(userId: user.id, reason: reason);
        },
      ),
    );
  }

  void _unblockUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.lock_open, color: AppColors.success),
            SizedBox(width: 8),
            Text('فك الحظر',
                style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Text(
          'هل تريد فك حظر "${user.name}"؟\nسيقدر العميل يطلب من جديد.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success),
            icon: const Icon(Icons.check, size: 16),
            label: const Text('فك الحظر'),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<UsersCubit>().unblockUser(user.id);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // نجيب الـ orders للحساب
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (prev, current) {
        if (current is OrdersLoading && prev is OrdersLoaded) return false;
        return true;
      },
      builder: (context, ordersState) {
        // فلتر طلبات هذا العميل بالذات
        final allOrders = ordersState is OrdersLoaded
            ? (ordersState.orders.items as List).cast<OrderEntity>()
            : <OrderEntity>[];
        final userOrders =
        allOrders.where((o) => o.userId == user.id).toList();
        final stats = CustomerStats(userOrders);

        return Container(
          color: AppColors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroHeader(stats),
                const SizedBox(height: 16),
                _buildContactSection(context),
                const SizedBox(height: 16),
                _buildAddressSection(),
                const SizedBox(height: 16),
                _buildStatsSection(stats),
                const SizedBox(height: 16),
                _buildLatestOrders(stats),
                const SizedBox(height: 16),
                _buildActionButtons(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ════ Hero ════
  Widget _buildHeroHeader(CustomerStats stats) {
    final isBlocked = user.isArchived;
    final tier = stats.tier;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isBlocked
              ? [
            AppColors.error.withValues(alpha: 0.25),
            AppColors.error.withValues(alpha: 0.05),
            AppColors.surface,
          ]
              : [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (isBlocked ? AppColors.error : AppColors.primary)
              .withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor:
                    AppColors.primary.withValues(alpha: 0.2),
                    child: Text(
                      _initials(user.name),
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                  if (isBlocked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.surface, width: 2),
                        ),
                        child: const Icon(Icons.block,
                            color: Colors.white, size: 14),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.name,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              decoration: isBlocked
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // التصنيف الذهبي/الفضي/إلخ
                        if (!isBlocked && tier != CustomerTier.regular)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.warning
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.warning
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(tier.emoji,
                                    style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 3),
                                Text(
                                  tier.arabicName,
                                  style: const TextStyle(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'ID: ${user.id.substring(0, 8).toUpperCase()}',
                        style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 10,
                            fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isBlocked) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.block, color: AppColors.error, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'هذا العميل محظور من إجراء طلبات جديدة',
                      style: TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (stats.isSuspicious) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber,
                      color: AppColors.warning, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '⚠️ نسبة إلغاء عالية: ${stats.cancellationRate.toStringAsFixed(0)}% من الطلبات',
                      style: const TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ════ Contact ════
  Widget _buildContactSection(BuildContext context) {
    final hasPhone =
        user.phoneNumber != null && user.phoneNumber!.isNotEmpty;

    return _section(
      title: 'التواصل',
      icon: Icons.contact_phone,
      accent: AppColors.info,
      child: Column(
        children: [
          _infoRow(Icons.email, 'البريد الإلكتروني', user.email),
          if (hasPhone) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.phone,
                      color: AppColors.info, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('رقم التليفون',
                            style: TextStyle(
                                color: AppColors.textHint, fontSize: 10)),
                        Text(
                          user.phoneNumber!,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              fontSize: 14),
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.call,
                        color: AppColors.success, size: 22),
                    tooltip: 'اتصال',
                    onPressed: () => _callPhone(user.phoneNumber!),
                  ),
                  IconButton(
                    icon: const Icon(Icons.message,
                        color: Color(0xFF25D366), size: 22),
                    tooltip: 'واتساب',
                    onPressed: () => _whatsapp(user.phoneNumber!),
                  ),
                ],
              ),
            ),
          ] else
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.phone_disabled,
                        color: AppColors.textHint, size: 16),
                    SizedBox(width: 8),
                    Text('لا يوجد رقم تليفون مسجل',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 12)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ════ Address ════
  Widget _buildAddressSection() {
    final hasAddress =
        user.address != null && user.address!.isNotEmpty;
    if (!hasAddress) {
      return _section(
        title: 'العنوان',
        icon: Icons.location_on,
        accent: AppColors.error,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('لا يوجد عنوان مسجل',
              style: TextStyle(color: AppColors.textHint)),
        ),
      );
    }
    final gps = GpsHelper.extractFromAddress(user.address!);
    final cleanAddress = GpsHelper.cleanAddress(user.address!);

    return _section(
      title: 'العنوان',
      icon: Icons.location_on,
      accent: AppColors.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cleanAddress.isEmpty ? user.address! : cleanAddress,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 13)),
          if (gps != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _openMap(gps.googleMapsUrl),
                icon: const Icon(Icons.map, size: 16),
                label: const Text('فتح في خرائط جوجل'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ════ Stats ════
  Widget _buildStatsSection(CustomerStats stats) {
    return _section(
      title: 'الإحصائيات',
      icon: Icons.bar_chart,
      accent: AppColors.accent,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _statCard(
                    Icons.shopping_basket,
                    '${stats.totalOrders}',
                    'إجمالي الطلبات',
                    AppColors.info),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statCard(
                    Icons.attach_money,
                    'L.E ${stats.totalSpent.toStringAsFixed(0)}',
                    'إجمالي الشراء',
                    AppColors.success),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _statCard(
                    Icons.check_circle,
                    '${stats.deliveredOrders}',
                    'مكتمل',
                    AppColors.success),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statCard(
                    Icons.cancel,
                    '${stats.cancelledOrders}',
                    'ملغي',
                    AppColors.error),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _statCard(
                    Icons.shopping_bag,
                    'L.E ${stats.averageOrderValue.toStringAsFixed(0)}',
                    'متوسط الطلب',
                    AppColors.accent),
              ),
            ],
          ),
          if (stats.lastOrderDate != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time,
                      color: AppColors.textHint, size: 16),
                  const SizedBox(width: 8),
                  Text('آخر طلب: ',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 12)),
                  Text(
                    _formatDate(stats.lastOrderDate!),
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ════ Latest Orders ════
  Widget _buildLatestOrders(CustomerStats stats) {
    final latest = stats.latestOrders(limit: 5);
    if (latest.isEmpty) {
      return _section(
        title: 'آخر الطلبات',
        icon: Icons.history,
        accent: AppColors.primary,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Text('لا توجد طلبات سابقة',
                style: TextStyle(color: AppColors.textHint)),
          ),
        ),
      );
    }

    // نجيب الترقيم اليومي
    final numbering = DailyOrderNumbering(stats.userOrders);

    return _section(
      title: 'آخر ${latest.length} طلبات',
      icon: Icons.history,
      accent: AppColors.primary,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text('${stats.totalOrders}',
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11)),
      ),
      child: Column(
        children: latest.map((order) {
          final dailyNum = numbering.getNumberFor(order.id);
          return _orderRow(order, dailyNum);
        }).toList(),
      ),
    );
  }

  Widget _orderRow(OrderEntity order, int dailyNum) {
    final statusColor = _orderStatusColor(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border(right: BorderSide(color: statusColor, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '#${dailyNum.toString().padLeft(3, '0')}',
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.orderItems.length} منتج • ${order.itemsCount} قطعة',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                Text(
                  _formatDate(order.createdDateTime),
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 10),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'L.E ${order.totalAmount.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _orderStatusLabel(order.status),
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ════ Actions ════
  Widget _buildActionButtons(BuildContext context) {
    final isBlocked = user.isArchived;
    return BlocBuilder<UsersCubit, UsersState>(
      buildWhen: (_, c) => c is UserActionLoading || c is UsersLoaded,
      builder: (context, state) {
        final isLoading = state is UserActionLoading;
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading
                ? null
                : () => isBlocked
                ? _unblockUser(context)
                : _blockUser(context),
            icon: isLoading
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
                : Icon(isBlocked ? Icons.lock_open : Icons.block,
                size: 20),
            label: Text(
              isLoading
                  ? 'جاري التحديث...'
                  : (isBlocked ? 'فك حظر العميل' : 'حظر العميل'),
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
              isBlocked ? AppColors.success : AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        );
      },
    );
  }

  // ════ Helpers ════
  Widget _section({
    required String title,
    required IconData icon,
    required Color accent,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.2),
                  accent.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(12), child: child),
        ],
      ),
    );
  }

  Widget _statCard(
      IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
                color: AppColors.textHint, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 8),
        Text('$label: ',
            style:
            const TextStyle(color: AppColors.textHint, fontSize: 12)),
        Expanded(
          child: Text(value,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].characters.take(1).toString();
    return '${parts[0].characters.take(1)}${parts[1].characters.take(1)}';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} - $h:$m';
  }

  Color _orderStatusColor(int status) {
    switch (status) {
      case 0:
        return AppColors.warning;
      case 1:
        return AppColors.info;
      case 2:
        return AppColors.accent;
      case 3:
        return AppColors.primary;
      case 4:
        return AppColors.success;
      case 5:
        return AppColors.error;
      default:
        return AppColors.textHint;
    }
  }

  String _orderStatusLabel(int status) {
    switch (status) {
      case 0:
        return 'قيد الانتظار';
      case 1:
        return 'مؤكد';
      case 2:
        return 'قيد التحضير';
      case 3:
        return 'في الطريق';
      case 4:
        return 'تم التوصيل';
      case 5:
        return 'ملغي';
      default:
        return 'غير معروف';
    }
  }
}
