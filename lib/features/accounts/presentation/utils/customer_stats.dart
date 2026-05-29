import '../../../orders/domain/entities/order_entity.dart';

class CustomerStats {
  final List<OrderEntity> userOrders;

  CustomerStats(this.userOrders);

  String _normalizedStatusName(OrderEntity order) =>
      order.statusName.trim().toLowerCase();

  bool _isDelivered(OrderEntity order) {
    final statusName = _normalizedStatusName(order);
    return statusName == 'delivered' ||
        statusName == 'completed' ||
        statusName == 'complete' ||
        statusName == 'تم التوصيل' ||
        statusName == 'مكتمل';
  }

  bool _isCancelled(OrderEntity order) {
    final statusName = _normalizedStatusName(order);
    return statusName == 'cancelled' ||
        statusName == 'canceled' ||
        statusName == 'ملغي';
  }

  int get totalOrders => userOrders.length;

  double get totalSpent =>
      userOrders.fold(0.0, (sum, o) => sum + o.totalAmount);

  int get deliveredOrders => userOrders.where(_isDelivered).length;

  int get cancelledOrders => userOrders.where(_isCancelled).length;

  int get inProgressOrders =>
      userOrders.where((o) => !_isDelivered(o) && !_isCancelled(o)).length;

  double get averageOrderValue =>
      totalOrders == 0 ? 0 : totalSpent / totalOrders;

  double get cancellationRate =>
      totalOrders == 0 ? 0 : (cancelledOrders / totalOrders) * 100;

  DateTime? get lastOrderDate {
    if (userOrders.isEmpty) return null;
    return userOrders
        .map((o) => o.createdDateTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  List<OrderEntity> latestOrders({int limit = 5}) {
    final sorted = [...userOrders]
      ..sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
    return sorted.take(limit).toList();
  }

  CustomerTier get tier {
    if (totalSpent >= 5000) return CustomerTier.gold;
    if (totalSpent >= 2000) return CustomerTier.silver;
    if (totalSpent >= 500) return CustomerTier.bronze;
    return CustomerTier.regular;
  }

  bool get isSuspicious => totalOrders >= 3 && cancellationRate >= 50;
}

enum CustomerTier {
  regular('عادي', 'Regular', '🟢'),
  bronze('برونزي', 'Bronze', '🥉'),
  silver('فضي', 'Silver', '🥈'),
  gold('ذهبي', 'Gold', '🥇');

  final String arabicName;
  final String englishName;
  final String emoji;
  const CustomerTier(this.arabicName, this.englishName, this.emoji);
}
