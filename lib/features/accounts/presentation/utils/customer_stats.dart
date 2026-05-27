import '../../../orders/domain/entities/order_entity.dart';

/// 📊 إحصائيات العميل المحسوبة من الطلبات
class CustomerStats {
  final List<OrderEntity> userOrders;

  CustomerStats(this.userOrders);

  int get totalOrders => userOrders.length;

  double get totalSpent =>
      userOrders.fold(0.0, (sum, o) => sum + o.totalAmount);

  int get deliveredOrders =>
      userOrders.where((o) => o.status == 4).length;

  int get cancelledOrders =>
      userOrders.where((o) => o.status == 5).length;

  int get inProgressOrders =>
      userOrders.where((o) => o.status >= 0 && o.status <= 3).length;

  double get averageOrderValue =>
      totalOrders == 0 ? 0 : totalSpent / totalOrders;

  /// نسبة الإلغاء % (مؤشر مهم للأدمن)
  double get cancellationRate =>
      totalOrders == 0 ? 0 : (cancelledOrders / totalOrders) * 100;

  /// أحدث طلب
  DateTime? get lastOrderDate {
    if (userOrders.isEmpty) return null;
    return userOrders
        .map((o) => o.createdDateTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  /// آخر N طلبات (الأحدث أولاً)
  List<OrderEntity> latestOrders({int limit = 5}) {
    final sorted = [...userOrders]
      ..sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));
    return sorted.take(limit).toList();
  }

  /// تصنيف العميل تلقائياً حسب الإنفاق
  CustomerTier get tier {
    if (totalSpent >= 5000) return CustomerTier.gold;
    if (totalSpent >= 2000) return CustomerTier.silver;
    if (totalSpent >= 500) return CustomerTier.bronze;
    return CustomerTier.regular;
  }

  /// هل العميل مشكوك فيه؟ (نسبة إلغاء عالية)
  bool get isSuspicious =>
      totalOrders >= 3 && cancellationRate >= 50;
}

enum CustomerTier {
  regular('عادي', '🟢'),
  bronze('برونزي', '🥉'),
  silver('فضي', '🥈'),
  gold('ذهبي', '🥇');

  final String arabicName;
  final String emoji;
  const CustomerTier(this.arabicName, this.emoji);
}
