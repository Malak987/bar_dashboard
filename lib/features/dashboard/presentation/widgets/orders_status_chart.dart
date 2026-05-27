import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/dashboard_calculations.dart';

class OrdersStatusChart extends StatelessWidget {
  final DashboardCalculations calc;
  const OrdersStatusChart({super.key, required this.calc});

  @override
  Widget build(BuildContext context) {
    final data = calc.getOrdersStatusBreakdown();
    final total = data.values.fold(0, (a, b) => a + b);

    // ألوان لكل حالة
    final colors = {
      'قيد الانتظار': AppColors.warning,
      'مؤكد': AppColors.info,
      'قيد التحضير': AppColors.accent,
      'في الطريق': AppColors.primary,
      'تم التوصيل': AppColors.success,
      'ملغي': AppColors.error,
    };

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
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الطلبات حسب الحالة',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'توزيع الطلبات الحالية',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
              Icon(Icons.pie_chart_outline, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          if (total == 0)
            const SizedBox(
              height: 200,
              child: Center(
                child: Text('لا توجد طلبات',
                    style: TextStyle(color: AppColors.textHint)),
              ),
            )
          else
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 3,
                      centerSpaceRadius: 55,
                      sections: data.entries
                          .where((e) => e.value > 0)
                          .map((e) {
                        final percent = (e.value / total * 100);
                        return PieChartSectionData(
                          value: e.value.toDouble(),
                          color: colors[e.key] ?? AppColors.primary,
                          title: '${percent.toStringAsFixed(0)}%',
                          radius: 50,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$total',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'إجمالي الطلبات',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
          // Legend
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: data.entries.where((e) => e.value > 0).map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (colors[e.key] ?? AppColors.primary)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors[e.key] ?? AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${e.key} (${e.value})',
                      style: TextStyle(
                        color: colors[e.key] ?? AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
