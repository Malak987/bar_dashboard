/// حالات الطلب من الباك إند
enum OrderStatus {
  pending(0, 'Pending', 'قيد الانتظار'),
  confirmed(1, 'Confirmed', 'مؤكد'),
  preparing(2, 'Preparing', 'قيد التحضير'),
  outForDelivery(3, 'OutForDelivery', 'في الطريق'),
  delivered(4, 'Delivered', 'تم التوصيل'),
  cancelled(5, 'Cancelled', 'ملغي');

  final int value;
  final String englishName;
  final String arabicName;
  const OrderStatus(this.value, this.englishName, this.arabicName);

  static OrderStatus fromValue(int value) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatus.pending,
    );
  }
}
