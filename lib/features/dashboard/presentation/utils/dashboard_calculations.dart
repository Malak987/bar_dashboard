import '../../../orders/domain/entities/order_entity.dart';

/// كلاس بيحسب الإحصائيات الحقيقية من بيانات الـ API
class DashboardCalculations {
  final List<OrderEntity> allOrders;

  /// 🆕 الإجمالي الحقيقي من الـ Backend (لو فيه pagination)
  /// لو null، بنستخدم allOrders.length
  final int? realTotalCount;

  DashboardCalculations(this.allOrders, {this.realTotalCount});

  /// 🎯 العدد الكلي: من الـ API لو متوفر، غير كده من اللست
  int get totalOrdersCount => realTotalCount ?? allOrders.length;

  int get deliveredOrdersCount =>
      allOrders.where((o) => o.status == 4).length;

  int get inProgressOrdersCount =>
      allOrders.where((o) => o.status >= 0 && o.status <= 3).length;

  int get cancelledOrdersCount =>
      allOrders.where((o) => o.status == 5).length;

  double get totalRevenue =>
      allOrders.fold(0.0, (sum, o) => sum + o.totalAmount);

  double get todayRevenue {
    final today = DateTime.now();
    return allOrders
        .where((o) =>
    o.createdDateTime.year == today.year &&
        o.createdDateTime.month == today.month &&
        o.createdDateTime.day == today.day)
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  int get todayOrdersCount {
    final today = DateTime.now();
    return allOrders
        .where((o) =>
    o.createdDateTime.year == today.year &&
        o.createdDateTime.month == today.month &&
        o.createdDateTime.day == today.day)
        .length;
  }

  double get weekRevenue {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return allOrders
        .where((o) => o.createdDateTime.isAfter(weekAgo))
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get monthRevenue {
    final monthAgo = DateTime.now().subtract(const Duration(days: 30));
    return allOrders
        .where((o) => o.createdDateTime.isAfter(monthAgo))
        .fold(0.0, (sum, o) => sum + o.totalAmount);
  }

  double get averageOrderValue {
    if (allOrders.isEmpty) return 0;
    return totalRevenue / allOrders.length;
  }

  List<MapEntry<DateTime, double>> getLast7DaysRevenue() {
    final result = <MapEntry<DateTime, double>>[];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      final revenue = allOrders
          .where((o) =>
      o.createdDateTime.year == day.year &&
          o.createdDateTime.month == day.month &&
          o.createdDateTime.day == day.day)
          .fold(0.0, (sum, o) => sum + o.totalAmount);
      result.add(MapEntry(day, revenue));
    }
    return result;
  }

  Map<String, int> getOrdersStatusBreakdown() {
    return {
      'قيد الانتظار': allOrders.where((o) => o.status == 0).length,
      'مؤكد': allOrders.where((o) => o.status == 1).length,
      'قيد التحضير': allOrders.where((o) => o.status == 2).length,
      'في الطريق': allOrders.where((o) => o.status == 3).length,
      'تم التوصيل': allOrders.where((o) => o.status == 4).length,
      'ملغي': allOrders.where((o) => o.status == 5).length,
    };
  }

  /// أكثر المنتجات مبيعاً (top N)
  List<MapEntry<String, int>> getTopProducts({int limit = 5}) {
    final productSales = <String, int>{};
    for (final order in allOrders) {
      for (final item in order.orderItems) {
        final name = item.productNameAr ?? '⚠️ منتج محذوف';
        productSales.update(
          name,
              (count) => count + item.quantity,
          ifAbsent: () => item.quantity,
        );
      }
    }
    final sorted = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }
}
