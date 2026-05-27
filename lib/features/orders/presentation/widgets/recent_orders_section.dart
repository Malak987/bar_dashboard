import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/utils/daily_order_numbering.dart';
import '../../../orders/presentation/cubit/orders_cubit.dart';

class RecentOrdersSection extends StatelessWidget {
  const RecentOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text('عرض الكل »',
                    style: TextStyle(color: AppColors.primary)),
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'آخر الطلبات',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('أحدث المعاملات',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 🎯 BlocBuilder ذكي: يعرض الـ loading فقط لو مفيش بيانات قديمة
          BlocBuilder<OrdersCubit, OrdersState>(
            // buildWhen: نعيد البناء فقط لو State بيانات (مش loading)
            buildWhen: (previous, current) {
              // لو الـ current هو OrdersLoaded أو OrdersFailure، rebuild
              // لو OrdersLoading، rebuild فقط لو مكنش عندنا بيانات قديمة
              if (current is OrdersLoaded || current is OrdersFailure) {
                return true;
              }
              if (current is OrdersLoading && previous is! OrdersLoaded) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is OrdersLoading) {
                return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ));
              }
              if (state is OrdersFailure) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(state.message,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                );
              }
              if (state is OrdersLoaded) {
                final allOrders =
                (state.orders.items as List).cast<OrderEntity>();
                // الترقيم من كل الأوردرات (مش بس الـ 5 الأخيرة)
                final numbering = DailyOrderNumbering(allOrders);
                final orders = allOrders.take(5).toList();
                if (orders.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text('لا توجد طلبات حالياً',
                          style:
                          TextStyle(color: AppColors.textSecondary)),
                    ),
                  );
                }
                return Column(
                  children: orders
                      .map((o) => _OrderRow(
                    order: o,
                    dailyNumber: numbering.getNumberFor(o.id),
                  ))
                      .toList(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final OrderEntity order;
  final int dailyNumber;
  const _OrderRow({required this.order, required this.dailyNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            'L.E ${order.totalAmount.toStringAsFixed(0)}',
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          const Spacer(),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _statusColor(order.status).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _statusLabel(order.status),
              style: TextStyle(
                color: _statusColor(order.status),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '#${dailyNumber.toString().padLeft(3, '0')}',
                style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                order.userName,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.receipt_long,
                color: AppColors.primary, size: 18),
          ),
        ],
      ),
    );
  }

  String _statusLabel(int status) {
    switch (status) {
      case 0:
        return 'قيد التحضير';
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

  Color _statusColor(int status) {
    switch (status) {
      case 4:
        return AppColors.success;
      case 5:
        return AppColors.error;
      case 3:
        return AppColors.info;
      default:
        return AppColors.warning;
    }
  }
}
