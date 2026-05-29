import 'package:flutter/material.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';

class OrderListCard extends StatelessWidget {
  final OrderEntity order;
  final int dailyNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const OrderListCard({
    super.key,
    required this.order,
    required this.dailyNumber,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = OrderStatus.fromValue(order.status);
    final statusColor = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '#${dailyNumber.toString().padLeft(3, '0')}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  order.id.substring(0, 6).toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 8,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _formatTime(context, order.createdDateTime),
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _localizedStatus(context, status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                          child: const Icon(Icons.person, size: 14, color: AppColors.primary),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            order.userName,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildProductsRow(context),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: AppColors.border, thickness: 0.5),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shopping_basket, size: 12, color: AppColors.textHint),
                            const SizedBox(width: 4),
                            Text(
                              '${order.itemsCount} ${context.l10n.productsAndPieces(0, order.itemsCount).split('/').last.trim()}',
                              style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                            ),
                          ],
                        ),
                        Text(
                          'L.E ${order.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductsRow(BuildContext context) {
    final l10n = context.l10n;
    final items = order.orderItems;
    if (items.isEmpty) {
      return Text(
        l10n.noMatchingResults,
        style: const TextStyle(color: AppColors.textHint, fontSize: 11),
      );
    }
    final displayCount = items.length > 3 ? 3 : items.length;
    final remaining = items.length - displayCount;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36 + (displayCount - 1) * 22,
            height: 36,
            child: Stack(
              children: List.generate(displayCount, (i) {
                final item = items[i];
                return Positioned(
                  right: i * 22.0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2),
                    ),
                    child: ClipOval(
                      child: item.fullProductImageUrl != null
                          ? Image.network(
                              item.fullProductImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _itemPlaceholder(),
                              loadingBuilder: (_, child, p) => p == null ? child : _itemPlaceholder(),
                            )
                          : _itemPlaceholder(),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items.first.safeProductNameAr,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (items.length > 1)
                  Text(
                    items.length == 2
                        ? '+ ${items[1].safeProductNameAr}'
                        : l10n.otherProductsCount(remaining + (items.length - 1)),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                else
                  Text(
                    l10n.quantityLabel(items.first.quantity),
                    style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemPlaceholder() => Container(
        color: AppColors.border,
        child: const Icon(Icons.cake, color: AppColors.textHint, size: 16),
      );

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

  String _formatTime(BuildContext context, DateTime dt) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(dt.year, dt.month, dt.day);
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');

    if (orderDate == today) {
      final diff = now.difference(dt);
      if (diff.inMinutes < 1) return l10n.now;
      if (diff.inMinutes < 60) return l10n.minutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return l10n.todayTime('$h:$m');
    }
    final diff = today.difference(orderDate).inDays;
    if (diff == 1) return l10n.yesterdayTime('$h:$m');
    if (diff < 7) return l10n.daysAgo(diff);
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
