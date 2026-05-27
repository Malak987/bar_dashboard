import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_method.dart';

/// 🦸 Hero Header - الرأس الكبير في صفحة تفاصيل الطلب
class OrderHeroHeader extends StatelessWidget {
  final OrderEntity order;
  final int dailyNumber;

  const OrderHeroHeader({
    super.key,
    required this.order,
    required this.dailyNumber,
  });

  @override
  Widget build(BuildContext context) {
    final status = OrderStatus.fromValue(order.status);
    final statusColor = _statusColor(status);
    final payment = order.paymentMethod;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.25),
            AppColors.primary.withValues(alpha: 0.05),
            AppColors.surface,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border:
        Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ═════ السطر الأول: رقم الطلب + شارة الحالة الكبيرة ═════
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.receipt_long,
                    color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // 🔢 الرقم اليومي - كبير وواضح
                        Text(
                          '#${dailyNumber.toString().padLeft(3, '0')}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color:
                              AppColors.warning.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Text(
                            'طلب اليوم',
                            style: TextStyle(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                                fontSize: 9),
                          ),
                        ),
                        const Spacer(),
                        // 🆔 الـ ID الأصلي - صغير في الجنب (للمرجع)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.id.substring(0, 8).toUpperCase(),
                            style: const TextStyle(
                                color: AppColors.textHint,
                                fontFamily: 'monospace',
                                fontSize: 9),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 13, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(order.createdDateTime),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 🎯 شارة الحالة الكبيرة
              _bigStatusBadge(status, statusColor),
            ],
          ),

          const SizedBox(height: 20),

          // ═════ السطر الثاني: 3 كروت إحصائيات كبيرة ═════
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.person,
                  iconColor: AppColors.info,
                  label: 'العميل',
                  value: order.userName,
                  valueFontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  icon: Icons.shopping_basket,
                  iconColor: AppColors.accent,
                  label: 'الأصناف',
                  value: '${order.itemsCount}',
                  valueFontSize: 22,
                  subValue: 'قطعة',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _statCard(
                  icon: Icons.payments,
                  iconColor: AppColors.success,
                  label: 'الإجمالي',
                  value: 'L.E ${order.totalAmount.toStringAsFixed(0)}',
                  valueFontSize: 22,
                  valueColor: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ═════ السطر الثالث: حالة الدفع ═════
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _paymentBgColor(payment, order.isPaid),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _paymentColor(payment, order.isPaid)
                    .withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _paymentColor(payment, order.isPaid),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _paymentIcon(payment),
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'طريقة الدفع',
                      style: TextStyle(
                          color: AppColors.textHint, fontSize: 11),
                    ),
                    Text(
                      payment.arabicName,
                      style: TextStyle(
                          color: _paymentColor(payment, order.isPaid),
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Spacer(),
                _paidStatusBadge(order.isPaid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═════════════════ Helpers ═════════════════

  Widget _bigStatusBadge(OrderStatus status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), color: Colors.white, size: 20),
          const SizedBox(height: 2),
          Text(
            status.arabicName,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    double valueFontSize = 16,
    Color? valueColor,
    String? subValue,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: iconColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                      color: valueColor ?? AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: valueFontSize),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subValue != null) ...[
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      subValue,
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paidStatusBadge(bool? isPaid) {
    if (isPaid == null) {
      return Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.textHint.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.help_outline,
                color: AppColors.textHint, size: 14),
            SizedBox(width: 4),
            Text(
              'غير محدد',
              style: TextStyle(
                  color: AppColors.textHint,
                  fontWeight: FontWeight.bold,
                  fontSize: 11),
            ),
          ],
        ),
      );
    }

    final color = isPaid ? AppColors.success : AppColors.warning;
    final icon = isPaid ? Icons.check_circle : Icons.pending_actions;
    final label = isPaid ? 'مدفوع ✓' : 'لم يُدفع';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11),
          ),
        ],
      ),
    );
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.confirmed:
        return AppColors.info;
      case OrderStatus.preparing:
        return AppColors.accent;
      case OrderStatus.outForDelivery:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  IconData _statusIcon(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return Icons.hourglass_empty;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.preparing:
        return Icons.restaurant;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color _paymentColor(PaymentMethod p, bool? isPaid) {
    if (isPaid == false) return AppColors.warning;
    switch (p) {
      case PaymentMethod.cash:
        return AppColors.success;
      case PaymentMethod.online:
      case PaymentMethod.card:
        return AppColors.info;
      case PaymentMethod.wallet:
        return AppColors.accent;
      case PaymentMethod.unknown:
        return AppColors.textHint;
    }
  }

  Color _paymentBgColor(PaymentMethod p, bool? isPaid) {
    return _paymentColor(p, isPaid).withValues(alpha: 0.1);
  }

  IconData _paymentIcon(PaymentMethod p) {
    switch (p) {
      case PaymentMethod.cash:
        return Icons.payments;
      case PaymentMethod.online:
        return Icons.language;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.wallet:
        return Icons.account_balance_wallet;
      case PaymentMethod.unknown:
        return Icons.help_outline;
    }
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} - $h:$m';
  }
}
