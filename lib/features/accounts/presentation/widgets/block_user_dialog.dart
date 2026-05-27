import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';

/// 🚫 Dialog لحظر العميل مع سبب
class BlockUserDialog extends StatefulWidget {
  final UserEntity user;

  /// callback لما الأدمن يأكد الحظر مع السبب
  final void Function(String reason) onConfirm;

  const BlockUserDialog({
    super.key,
    required this.user,
    required this.onConfirm,
  });

  @override
  State<BlockUserDialog> createState() => _BlockUserDialogState();
}

class _BlockUserDialogState extends State<BlockUserDialog> {
  final _reasonController = TextEditingController();
  String? _selectedReason;

  static const _commonReasons = [
    'كثرة إلغاء الطلبات',
    'عميل مزعج / تعليقات سيئة',
    'محاولات احتيال',
    'عدم استلام الطلبات المؤكدة',
    'رفض الدفع عند الاستلام',
    'سلوك غير لائق',
    'سبب آخر',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    String finalReason = '';
    if (_selectedReason != null && _selectedReason != 'سبب آخر') {
      finalReason = _selectedReason!;
    }
    if (_reasonController.text.trim().isNotEmpty) {
      finalReason = finalReason.isEmpty
          ? _reasonController.text.trim()
          : '$finalReason - ${_reasonController.text.trim()}';
    }
    if (finalReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار أو كتابة سبب الحظر'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    Navigator.of(context).pop();
    widget.onConfirm(finalReason);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.block,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('حظر العميل',
                            style: TextStyle(
                                color: AppColors.error,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        Text(widget.user.name,
                            style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('سبب الحظر:',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  const SizedBox(height: 10),
                  // أسباب جاهزة
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _commonReasons.map((reason) {
                      final isSelected = _selectedReason == reason;
                      return InkWell(
                        onTap: () =>
                            setState(() => _selectedReason = reason),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.error
                                : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.error
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            reason,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  // سبب مخصص
                  TextField(
                    controller: _reasonController,
                    maxLines: 2,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      labelText: 'تفاصيل إضافية (اختياري)',
                      hintText: 'اكتب أي تفاصيل تخص الحظر...',
                      prefixIcon: Icon(Icons.edit_note),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        right:
                        BorderSide(color: AppColors.warning, width: 3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppColors.warning, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'العميل لن يقدر يعمل طلبات جديدة لحد ما تفك الحظر',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.block),
                      label: const Text('تأكيد الحظر'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
