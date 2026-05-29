import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/shop_info.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/gps_helper.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../../../branches/presentation/cubit/branches_cubit.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status.dart';
import '../cubit/orders_cubit.dart';
import '../services/invoice_actions.dart';
import 'customer_phone_loader.dart';
import 'order_hero_header.dart';
import 'order_status_stepper.dart';
import 'section_card.dart';

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

  _ResolvedBranchInfo _resolveBranchInfo(BuildContext context) {
    final branchesState = context.read<BranchesCubit>().state;
    if (branchesState is BranchesLoaded) {
      final branch = _findBranchFromApi(branchesState.branches.items);
      if (branch != null) {
        return _ResolvedBranchInfo(
          nameAr: branch.nameAr,
          nameEn: branch.nameEn,
          addressAr: branch.addressAr,
          addressEn: branch.addressEn,
          phones: [branch.phone],
        );
      }
    }

    final fallback = ShopInfo.branchFromOrder(
      branchId: order.branchId,
      branchName: order.branchName,
    );
    return _ResolvedBranchInfo(
      nameAr: fallback.nameAr,
      nameEn: fallback.nameEn,
      addressAr: fallback.addressAr,
      addressEn: fallback.addressEn,
      phones: fallback.phones,
    );
  }

  BranchEntity? _findBranchFromApi(List<BranchEntity> branches) {
    final normalizedBranchId = order.branchId?.trim().toLowerCase();
    final normalizedBranchName = order.branchName?.trim().toLowerCase();

    for (final branch in branches) {
      if (normalizedBranchId != null &&
          normalizedBranchId.isNotEmpty &&
          branch.id.trim().toLowerCase() == normalizedBranchId) {
        return branch;
      }

      if (normalizedBranchName != null && normalizedBranchName.isNotEmpty) {
        final branchNameAr = branch.nameAr.trim().toLowerCase();
        final branchNameEn = branch.nameEn.trim().toLowerCase();
        if (branchNameAr == normalizedBranchName ||
            branchNameEn == normalizedBranchName ||
            branchNameAr.contains(normalizedBranchName) ||
            branchNameEn.contains(normalizedBranchName) ||
            normalizedBranchName.contains(branchNameAr) ||
            normalizedBranchName.contains(branchNameEn)) {
          return branch;
        }
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final gps = GpsHelper.extractFromAddress(order.address);
    final cleanAddress = GpsHelper.cleanAddress(order.address);
    final branch = _resolveBranchInfo(context);

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OrderHeroHeader(order: order, dailyNumber: dailyNumber),
            const SizedBox(height: 16),
            _buildInvoiceActions(context),
            const SizedBox(height: 16),
            _buildStatusStepper(context),
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 700) {
                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _buildCustomerSection(context),
                              const SizedBox(height: 16),
                              _buildBranchSection(context, branch),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildAddressSection(context, cleanAddress, gps),
                        ),
                      ],
                    ),
                  );
                }
                return Column(
                  children: [
                    _buildCustomerSection(context),
                    const SizedBox(height: 16),
                    _buildAddressSection(context, cleanAddress, gps),
                    const SizedBox(height: 16),
                    _buildBranchSection(context, branch),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            _buildItemsSection(context),
            const SizedBox(height: 16),
            _buildTotalsSection(context),
            if (order.note != null && order.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildNotesSection(context),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceActions(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.invoiceSectionTitle,
      subtitle: l10n.invoiceSectionSubtitle,
      icon: Icons.print,
      accentColor: AppColors.accent,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _actionButton(
            icon: Icons.print,
            label: l10n.print,
            color: AppColors.primary,
            onPressed: () => InvoiceActions.printInvoice(context, order, dailyNumber: dailyNumber),
          ),
          _actionButton(
            icon: Icons.visibility,
            label: l10n.preview,
            color: AppColors.info,
            onPressed: () => InvoiceActions.previewInvoice(context, order, dailyNumber: dailyNumber),
            outlined: true,
          ),
          _actionButton(
            icon: Icons.download,
            label: l10n.savePdf,
            color: AppColors.textPrimary,
            onPressed: () => InvoiceActions.savePdf(context, order, dailyNumber: dailyNumber),
            outlined: true,
          ),
          _actionButton(
            icon: Icons.share,
            label: l10n.share,
            color: AppColors.success,
            onPressed: () => InvoiceActions.shareInvoice(context, order, dailyNumber: dailyNumber),
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
    );
  }

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

  Widget _buildCustomerSection(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.customerSectionTitle,
      subtitle: l10n.customerSectionSubtitle,
      icon: Icons.person,
      accentColor: AppColors.info,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  child: const Icon(Icons.person, color: AppColors.info, size: 28),
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
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${l10n.customerId}: ${order.userId.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CustomerPhoneLoader(userId: order.userId),
        ],
      ),
    );
  }

  Widget _buildAddressSection(
    BuildContext context,
    String cleanAddress,
    GpsCoordinates? gps,
  ) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.deliveryAddressTitle,
      subtitle: gps != null ? l10n.withGps : null,
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
                const Icon(Icons.place, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cleanAddress.isEmpty ? l10n.noAddressEntered : cleanAddress,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      height: 1.5,
                    ),
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
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.gps_fixed, color: AppColors.success, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        l10n.exactGps,
                        style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        gps.displayShort,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openMap(gps.googleMapsUrl),
                      icon: const Icon(Icons.map, size: 16),
                      label: Text(l10n.openInGoogleMaps),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 10),
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

  Widget _buildBranchSection(BuildContext context, _ResolvedBranchInfo branch) {
    final l10n = context.l10n;
    final branchName = Localizations.localeOf(context).languageCode == 'ar'
        ? branch.nameAr
        : branch.nameEn;
    final branchAddress = Localizations.localeOf(context).languageCode == 'ar'
        ? branch.addressAr
        : branch.addressEn;

    return SectionCard(
      title: l10n.preparationBranchTitle,
      subtitle: l10n.preparationBranchSubtitle,
      icon: Icons.store,
      accentColor: AppColors.warning,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            branchName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 14, color: AppColors.textHint),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  branchAddress,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: branch.phones.map((phone) {
              return InkWell(
                onTap: () => _callPhone(phone),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.phone, color: Colors.white, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        phone,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.itemsSectionTitle,
      subtitle: l10n.productsAndPieces(order.orderItems.length, order.itemsCount),
      icon: Icons.shopping_basket,
      accentColor: AppColors.primary,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '${order.orderItems.length}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
      child: Column(
        children: order.orderItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Container(
            margin: EdgeInsets.only(bottom: i < order.orderItems.length - 1 ? 10 : 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
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
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
                          fontSize: 14,
                        ),
                      ),
                      if (item.sizeName != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.sizePrefix(item.sizeName!),
                          style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                        ),
                      ],
                      if (item.flavors.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          l10n.flavorsPrefix(
                            item.flavors.map((f) => f.flavorNameAr ?? '').join('، '),
                          ),
                          style: const TextStyle(color: AppColors.accent, fontSize: 11),
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.info.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '× ${item.quantity}',
                              style: const TextStyle(
                                color: AppColors.info,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '@ ${item.unitPrice.toStringAsFixed(0)} L.E',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.orderTotal,
                      style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                    ),
                    Text(
                      'L.E ${item.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
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

  Widget _buildTotalsSection(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.totalsSectionTitle,
      subtitle: l10n.totalsSectionSubtitle,
      icon: Icons.calculate,
      accentColor: AppColors.success,
      child: Column(
        children: [
          _totalRow(l10n.subtotalLabel, 'L.E ${order.subtotal.toStringAsFixed(2)}'),
          _totalRow(l10n.deliveryFeeLabel, 'L.E ${order.deliveryFee.toStringAsFixed(2)}', icon: Icons.delivery_dining),
          if (order.discountAmount > 0)
            _totalRow(l10n.discountLabel, '- L.E ${order.discountAmount.toStringAsFixed(2)}', color: AppColors.success, icon: Icons.local_offer),
          const Divider(color: AppColors.border, height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.success,
                  AppColors.success.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.payments, color: Colors.white, size: 22),
                    const SizedBox(width: 10),
                    Text(
                      l10n.finalTotalLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  'L.E ${order.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final l10n = context.l10n;
    return SectionCard(
      title: l10n.notesSectionTitle,
      subtitle: l10n.notesSectionSubtitle,
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
            const Icon(Icons.format_quote, color: AppColors.warning, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                order.note!,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _totalRow(String label, String value, {Color? color, IconData? icon}) {
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
              Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResolvedBranchInfo {
  final String nameAr;
  final String nameEn;
  final String addressAr;
  final String addressEn;
  final List<String> phones;

  const _ResolvedBranchInfo({
    required this.nameAr,
    required this.nameEn,
    required this.addressAr,
    required this.addressEn,
    required this.phones,
  });
}
