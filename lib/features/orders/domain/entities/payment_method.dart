/// 💳 طريقة الدفع
/// ⚠️ ملاحظة: حالياً مش موجود في الـ Backend
/// لما تضيف الحقل، نقدر نقرأه من order.paymentMethod مباشرة
enum PaymentMethod {
  cash(0, 'كاش', 'Cash'),
  online(1, 'أونلاين', 'Online'),
  card(2, 'بطاقة', 'Card'),
  wallet(3, 'محفظة', 'Wallet'),
  unknown(-1, 'غير محدد', 'Unknown');

  final int value;
  final String arabicName;
  final String englishName;
  const PaymentMethod(this.value, this.arabicName, this.englishName);

  static PaymentMethod fromValue(int? value) {
    if (value == null) return PaymentMethod.unknown;
    return PaymentMethod.values.firstWhere(
          (e) => e.value == value,
      orElse: () => PaymentMethod.unknown,
    );
  }
}
