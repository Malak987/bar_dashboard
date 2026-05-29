import 'package:flutter/material.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/payment_method.dart';

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
    final l10n = context.l10n;
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
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '#${dailyNumber.toString().padLeft(3, '0')}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l10n.orders,
                            style: const TextStyle(
                              color: AppColors.warning,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            order.id.substring(0, 8).toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontFamily: 'monospace',
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 13, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          _formatDateTime(order.createdDateTime),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _bigStatusBadge(context, status, statusColor),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _statCard(
                  icon: Icons.person,
                  iconColor: AppColors.info,
                  label: l10n.customerSectionTitle,
                  value: order.userName,
                  valueFontSize: 14,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _statCard(
                  icon: Icons.shopping_basket,
                  iconColor: AppColors.accent,
                  label: l10n.itemsSectionTitle,
                  value: '${order.itemsCount}',
                  valueFontSize: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _statCard(
                  icon: Icons.payments,
                  iconColor: AppColors.success,
                  label: l10n.finalTotalLabel,
                  value: 'L.E ${order.totalAmount.toStringAsFixed(0)}',
                  valueFontSize: 22,
                  valueColor: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _paymentBgColor(payment, order.isPaid),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _paymentColor(payment, order.isPaid).withValues(alpha: 0.4),
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
                  child: Icon(_paymentIcon(payment), color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.invoiceSectionTitle,
                      style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                    ),
                    Text(
                      payment.arabicName,
                      style: TextStyle(
                        color: _paymentColor(payment, order.isPaid),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                _paidStatusBadge(context, order.isPaid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigStatusBadge(BuildContext context, OrderStatus status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_statusIcon(status), color: Colors.white, size: 20),
          const SizedBox(height: 2),
          Text(
            _localizedStatus(context, status),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
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
                  style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: valueFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paidStatusBadge(BuildContext context, bool? isPaid) {
    if (isPaid == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.textHint.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          context.l10n.unknown,
          style: const TextStyle(color: AppColors.textHint, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      );
    }

    final color = isPaid ? AppColors.success : AppColors.warning;
    final label = isPaid ? context.l10n.deliveredLabel : context.l10n.pendingStatus;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  String _localizedStatus(BuildContext context, OrderStatus status) {
    final l10n = context.l10n;
    switch (status) {
      case OrderStatus.pending:
        return l10n.pendingStatus;
      case OrderStatus.confirmed:
        return l10n.confirmedStatus;
      case OrderStatus.preparing:
        return l10n.preparingStatus;
      case OrderStatus.outForDelivery:
        return l10n.outForDeliveryStatus;
      case OrderStatus.delivered:
        return l10n.deliveredStatus;
      case OrderStatus.cancelled:
        return l10n.cancelledStatus;
    }
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

  Color _paymentBgColor(PaymentMethod p, bool? isPaid) =>
      _paymentColor(p, isPaid).withValues(alpha: 0.1);

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
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day}/${dt.month}/${dt.year} - $h:$m';
  }
}
