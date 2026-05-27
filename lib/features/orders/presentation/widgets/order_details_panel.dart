import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/shop_info.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gps_helper.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../cubit/orders_cubit.dart';
import '../services/invoice_actions.dart';
import 'customer_phone_loader.dart';
import 'order_hero_header.dart';
import 'order_status_stepper.dart';
import 'section_card.dart';

/// 📋 صفحة تفاصيل الطلب (الـ panel اليمين في الـ Master-Detail)
/// 🆕 تصميم جديد بـ Hero header + سكاشن واضحة بحدود ملونة
class OrderDetailsPanel extends StatelessWidget {
  final OrderEntity order;
  final int dailyNumber;

  const OrderDetailsPanel({
    super.key,
    required this.order,
    required this.dailyNumber,
  });

  Future<void> _openMap(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPhone(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gps = GpsHelper.extractFromAddress(order.address);
    final cleanAddress = GpsHelper.cleanAddress(order.address);
    final branch = ShopInfo.branchFromOrder(
      branchId: order.branchId,
      branchName: order.branchName,
    );

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🦸 Hero Header الجديد
            OrderHeroHeader(order: order, dailyNumber: dailyNumber),
            const SizedBox(height: 16),

            // 🖨️ أزرار الفاتورة (في الأعلى للوصول السريع)
            _buildInvoiceActions(context),
            const SizedBox(height: 16),

            // 📊 Status Stepper
            _buildStatusStepper(context),
            const SizedBox(height: 16),

            // 📋 السكاشن في عمودين على الشاشات الكبيرة
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 700) {
                  // Two columns layout
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildCustomerSection(),
                              const SizedBox(height: 16),
                              _buildBranchSection(branch),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAddressSection(cleanAddress, gps),
                        ),
                      ],
                    ),
                  );
                }
                // Single column for mobile
                return Column(
                  children: [
                    _buildCustomerSection(),
                    const SizedBox(height: 16),
                    _buildAddressSection(cleanAddress, gps),
                    const SizedBox(height: 16),
                    _buildBranchSection(branch),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // 🛒 الأصناف
            _buildItemsSection(),
            const SizedBox(height: 16),

            // 💰 الإجماليات
            _buildTotalsSection(),

            if (order.note != null && order.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildNotesSection(),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ═══════════ Invoice Actions ═══════════
  Widget _buildInvoiceActions(BuildContext context) {
    return SectionCard(
      title: 'الفاتورة',
      subtitle: 'طباعة، حفظ، أو مشاركة الفاتورة',
      icon: Icons.print,
      accentColor: AppColors.accent,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _actionButton(
            icon: Icons.print,
            label: 'طباعة',
            color: AppColors.primary,
            onPressed: () =>
                InvoiceActions.printInvoice(context, order, dailyNumber: dailyNumber),
          ),
          _actionButton(
            icon: Icons.visibility,
            label: 'معاينة',
            color: AppColors.info,
            onPressed: () =>
                InvoiceActions.previewInvoice(context, order, dailyNumber: dailyNumber),
            outlined: true,
          ),
          _actionButton(
            icon: Icons.download,
            label: 'حفظ PDF',
            color: AppColors.textPrimary,
            onPressed: () => InvoiceActions.savePdf(context, order, dailyNumber: dailyNumber),
            outlined: true,
          ),
          _actionButton(
            icon: Icons.share,
            label: 'مشاركة',
            color: AppColors.success,
            onPressed: () =>
                InvoiceActions.shareInvoice(context, order, dailyNumber: dailyNumber),
            outlined: true,
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          side: BorderSide(color: color.withValues(alpha: 0.5)),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }

  // ═══════════ Status Stepper ═══════════
  Widget _buildStatusStepper(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (_, current) =>
      current is OrderActionLoading ||
          current is OrderActionSuccess ||
          current is OrderActionFailure ||
          current is OrdersLoaded,
      builder: (context, state) {
        return OrderStatusStepper(
          currentStatus: OrderStatus.fromValue(order.status),
          isLoading: state is OrderActionLoading,
          onChangeStatus: (newStatus) {
            if (newStatus == OrderStatus.cancelled) {
              context.read<OrdersCubit>().adminCancelOrder(order.id);
            } else {
              context.read<OrdersCubit>().updateOrderStatus(
                orderId: order.id,
                newStatus: newStatus,
              );
            }
          },
        );
      },
    );
  }

  // ═══════════ Customer Section ═══════════
  Widget _buildCustomerSection() {
    return SectionCard(
      title: 'بيانات العميل',
      subtitle: 'معلومات صاحب الطلب',
      icon: Icons.person,
      accentColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // اسم العميل + ID
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.info.withValues(alpha: 0.2),
                  child: const Icon(Icons.person,
                      color: AppColors.info, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.userName,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'ID: ${order.userId.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 10,
                              fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // 📞 رقم التليفون (بيتحمّل من Users API)
          CustomerPhoneLoader(userId: order.userId),
        ],
      ),
    );
  }

  // ═══════════ Address Section ═══════════
  Widget _buildAddressSection(
      String cleanAddress, GpsCoordinates? gps) {
    return SectionCard(
      title: 'عنوان التوصيل',
      subtitle: gps != null ? 'مع إحداثيات GPS' : null,
      icon: Icons.location_on,
      accentColor: AppColors.error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.place,
                    color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cleanAddress.isEmpty
                        ? 'لا يوجد عنوان مدخل'
                        : cleanAddress,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          if (gps != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gps_fixed,
                          color: AppColors.success, size: 16),
                      const SizedBox(width: 6),
                      const Text('إحداثيات دقيقة',
                          style: TextStyle(
                              color: AppColors.success,
                              fontSize: 11,
                              fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text(
                        gps.displayShort,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openMap(gps.googleMapsUrl),
                      icon: const Icon(Icons.map, size: 16),
                      label: const Text('فتح في خرائط جوجل'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding:
                        const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════ Branch Section ═══════════
  Widget _buildBranchSection(BranchInfo branch) {
    return SectionCard(
      title: 'فرع التحضير',
      subtitle: 'الفرع المسؤول عن هذا الطلب',
      icon: Icons.store,
      accentColor: AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(branch.nameAr,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on,
                  size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  branch.addressAr,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: branch.phones
                .map((phone) => InkWell(
              onTap: () => _callPhone(phone),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.phone,
                        color: Colors.white, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      phone,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ═══════════ Items Section ═══════════
  Widget _buildItemsSection() {
    return SectionCard(
      title: 'الأصناف المطلوبة',
      subtitle: '${order.orderItems.length} منتج / ${order.itemsCount} قطعة',
      icon: Icons.shopping_basket,
      accentColor: AppColors.primary,
      trailing: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${order.orderItems.length}',
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13),
        ),
      ),
      child: Column(
        children: order.orderItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Container(
            margin: EdgeInsets.only(
                bottom: i < order.orderItems.length - 1 ? 10 : 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                // Number badge
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Image
                if (item.fullProductImageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.fullProductImageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _itemPlaceholder(),
                    ),
                  )
                else
                  _itemPlaceholder(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.safeProductNameAr,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      if (item.sizeName != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.straighten,
                                size: 11, color: AppColors.textHint),
                            const SizedBox(width: 4),
                            Text('الحجم: ${item.sizeName}',
                                style: const TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 11)),
                          ],
                        ),
                      ],
                      if (item.flavors.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.local_drink,
                                size: 11, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.flavors
                                    .map((f) => f.flavorNameAr ?? '')
                                    .join('، '),
                                style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 11),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('× ${item.quantity}',
                                style: const TextStyle(
                                    color: AppColors.info,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Text(
                              '@ ${item.unitPrice.toStringAsFixed(0)} L.E',
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Total price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('الإجمالي',
                        style: TextStyle(
                            color: AppColors.textHint, fontSize: 10)),
                    Text(
                      'L.E ${item.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _itemPlaceholder() => Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      color: AppColors.border,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Icon(Icons.cake, color: AppColors.textHint),
  );

  // ═══════════ Totals Section ═══════════
  Widget _buildTotalsSection() {
    return SectionCard(
      title: 'الحسابات',
      subtitle: 'ملخص المبالغ',
      icon: Icons.calculate,
      accentColor: AppColors.success,
      child: Column(
        children: [
          _totalRow('المجموع الفرعي',
              'L.E ${order.subtotal.toStringAsFixed(2)}'),
          _totalRow('رسوم التوصيل',
              'L.E ${order.deliveryFee.toStringAsFixed(2)}',
              icon: Icons.delivery_dining),
          if (order.discountAmount > 0)
            _totalRow('الخصم',
                '- L.E ${order.discountAmount.toStringAsFixed(2)}',
                color: AppColors.success, icon: Icons.local_offer),
          const Divider(color: AppColors.border, height: 24),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.payments,
                        color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text('الإجمالي النهائي',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Text(
                  'L.E ${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection() {
    return SectionCard(
      title: 'ملاحظات العميل',
      subtitle: 'تعليمات خاصة بالطلب',
      icon: Icons.sticky_note_2,
      accentColor: AppColors.warning,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            right: BorderSide(color: AppColors.warning, width: 3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.format_quote,
                color: AppColors.warning, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                order.note!,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.5,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String label, String value,
      {Color? color, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: AppColors.textHint),
                const SizedBox(width: 6),
              ],
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          Text(value,
              style: TextStyle(
                  color: color ?? AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }
}
