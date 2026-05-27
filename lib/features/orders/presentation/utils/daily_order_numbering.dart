import '../../domain/entities/order_entity.dart';

/// 🔢 Helper لحساب الترقيم اليومي للأوردرات
///
/// كل يوم يبدأ العداد من #1 من جديد
/// أول أوردر في اليوم = #1، الثاني = #2، إلخ
///
/// الترتيب: حسب وقت الإنشاء (الأقدم في اليوم = #1)
class DailyOrderNumbering {
  /// كل الأوردرات (مرتبة بأي ترتيب)
  final List<OrderEntity> allOrders;

  /// خريطة: order.id → daily number
  late final Map<String, int> _orderDailyNumbers;

  DailyOrderNumbering(this.allOrders) {
    _orderDailyNumbers = _calculate();
  }

  Map<String, int> _calculate() {
    // 1. نجمع الأوردرات حسب التاريخ (يوم/شهر/سنة)
    final Map<String, List<OrderEntity>> ordersByDay = {};

    for (final order in allOrders) {
      final key = _dayKey(order.createdDateTime);
      ordersByDay.putIfAbsent(key, () => []).add(order);
    }

    // 2. لكل يوم، نرتّب الأوردرات بالأقدم → الأحدث، ونرقّمهم
    final result = <String, int>{};
    for (final dayOrders in ordersByDay.values) {
      // ترتيب من الأقدم للأحدث عشان أول طلب في اليوم = #1
      dayOrders.sort(
              (a, b) => a.createdDateTime.compareTo(b.createdDateTime));

      for (int i = 0; i < dayOrders.length; i++) {
        result[dayOrders[i].id] = i + 1;
      }
    }
    return result;
  }

  /// الحصول على الرقم اليومي لأوردر معين
  /// لو الأوردر مش موجود، نرجع 0
  int getNumberFor(String orderId) => _orderDailyNumbers[orderId] ?? 0;

  /// نسخة مع padding ('001', '002', '023', ...)
  String getNumberFormatted(String orderId, {int digits = 3}) {
    final num = getNumberFor(orderId);
    return num.toString().padLeft(digits, '0');
  }

  /// تسمية اليوم (today / yesterday / date)
  static String dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final orderDate = DateTime(date.year, date.month, date.day);

    if (orderDate == today) return 'اليوم';

    final diff = today.difference(orderDate).inDays;
    if (diff == 1) return 'أمس';
    return '${date.day}/${date.month}/${date.year}';
  }

  static String _dayKey(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';
}
