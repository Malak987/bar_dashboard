import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/order_status.dart';

/// 🎯 Stepper Timeline لتغيير حالة الأوردر
class OrderStatusStepper extends StatelessWidget {
  final OrderStatus currentStatus;
  final void Function(OrderStatus newStatus)? onChangeStatus;
  final bool isLoading;

  const OrderStatusStepper({
    super.key,
    required this.currentStatus,
    this.onChangeStatus,
    this.isLoading = false,
  });

  static const _flow = [
    OrderStatus.pending,
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.outForDelivery,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    final isCancelled = currentStatus == OrderStatus.cancelled;
    final isDelivered = currentStatus == OrderStatus.delivered;

    // ✅ تأمين الـ index لو الـ indexOf رجع -1 لأي سبب
    int currentIndex = _flow.indexOf(currentStatus);
    if (currentIndex == -1) currentIndex = 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDelivered
              ? AppColors.success.withValues(alpha: 0.5)
              : isCancelled
              ? AppColors.error.withValues(alpha: 0.5)
              : AppColors.border,
          width: isDelivered || isCancelled ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isDelivered
                    ? Icons.check_circle
                    : isCancelled
                    ? Icons.cancel
                    : Icons.timeline,
                color: isDelivered
                    ? AppColors.success
                    : isCancelled
                    ? AppColors.error
                    : AppColors.primary,
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'حالة الطلب',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              _statusBadge(currentStatus),
            ],
          ),
          const SizedBox(height: 20),

          if (isCancelled)
            _cancelledView()
          else
            _stepperView(currentIndex, isDelivered),

          // ✅ لو متسلم: نعرض رسالة نجاح بدل أزرار التحكم
          if (isDelivered) ...[
            const SizedBox(height: 16),
            _deliveredSuccessBanner(),
          ] else if (!isCancelled) ...[
            const SizedBox(height: 20),
            const Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 16),
            _buildActionButtons(context, currentIndex),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(OrderStatus s) {
    final color = _colorOf(s);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconOf(s), color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            s.arabicName,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// 🎉 Banner نجاح لو الطلب اتسلم
  Widget _deliveredSuccessBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success,
            AppColors.success.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '✓ تم توصيل الطلب بنجاح',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'الطلب مكتمل ووصل للعميل',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cancelledView() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.cancel, color: AppColors.error, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚫 تم إلغاء هذا الطلب',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'لا يمكن تغيير حالة الطلب الملغي',
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🎯 الـ stepper - تم تعديل المنطق لضمان تلوين آخر خطوة
  Widget _stepperView(int currentIndex, bool isDelivered) {
    return Row(
      children: List.generate(_flow.length * 2 - 1, (i) {
        // رسم الخطوط بين الخطوات
        if (i.isOdd) {
          final lineIdx = i ~/ 2;
          // ✅ لو متسلم: كل الخطوط خضراء
          // ✅ لو لسه: الخط أخضر لو اللي قبله خلص
          final lineColor = isDelivered
              ? AppColors.success
              : lineIdx < currentIndex
              ? AppColors.primary
              : AppColors.border;
          return Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }

        // رسم الدوائر (الخطوات)
        final stepIdx = i ~/ 2;
        final step = _flow[stepIdx];

        // ✅ منطق محسّن: الخطوة تعتبر "مكتملة" لو رقمها أقل من الاندكس الحالي
        // أو لو الطلب كله متسلم (isDelivered)
        final isStepReached = stepIdx <= currentIndex;
        final isStepPast = stepIdx < currentIndex;
        final isStepCurrent = stepIdx == currentIndex;
        final isLastStep = stepIdx == _flow.length - 1;

        // تحديد اللون
        final color = isDelivered
            ? AppColors.success // لو الطلب متسلم، الكل أخضر
            : isStepReached
            ? _colorOf(step) // لو وصلناها، لون المرحلة
            : AppColors.border; // لو لسه، رمادي

        // تحديد الأيقونة (صح ولا أيقونة المرحلة)
        // تظهر علامة الصح لو الخطوة فاتت، أو لو الطلب كله متسلم
        final showCheckMark = isStepPast || isDelivered;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                // ✅ الخلفية: لو الخطوة الحالية أو مكتملة تلون
                color: isStepReached ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 2,
                ),
                boxShadow: (isStepCurrent && !isDelivered) || (isDelivered && isLastStep)
                    ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
                    : null,
              ),
              child: Center(
                child: showCheckMark
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : Icon(
                  _iconOf(step),
                  color: isStepReached ? Colors.white : AppColors.textHint,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 70,
              child: Text(
                step.arabicName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isStepReached ? FontWeight.bold : FontWeight.normal,
                  color: isStepReached
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButtons(BuildContext context, int currentIndex) {
    final nextStep = currentIndex + 1 < _flow.length
        ? _flow[currentIndex + 1]
        : null;

    return Row(
      children: [
        if (nextStep != null) ...[
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: isLoading || onChangeStatus == null
                  ? null
                  : () => onChangeStatus!(nextStep),
              icon: isLoading
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : Icon(_iconOf(nextStep), size: 18),
              label: Text(
                isLoading
                    ? 'جاري التحديث...'
                    : 'انتقل إلى: ${nextStep.arabicName}',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorOf(nextStep),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],

        Expanded(
          child: OutlinedButton.icon(
            onPressed: isLoading || onChangeStatus == null
                ? null
                : () => _confirmCancel(context),
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text('إلغاء'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 8),
            Text('تأكيد الإلغاء',
                style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من إلغاء هذا الطلب؟\nلا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('تراجع'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(ctx).pop();
              onChangeStatus?.call(OrderStatus.cancelled);
            },
            child: const Text('إلغاء الطلب'),
          ),
        ],
      ),
    );
  }

  Color _colorOf(OrderStatus s) {
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

  IconData _iconOf(OrderStatus s) {
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
}