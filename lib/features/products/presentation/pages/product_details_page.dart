import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../flavors/presentation/cubit/flavors_cubit.dart';
import '../../../product_sizes/presentation/cubit/product_sizes_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
import '../widgets/product_wizard_dialog.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsPage({super.key, required this.product});

  bool _isArabic(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  String _productName(BuildContext context) =>
      _isArabic(context) ? product.nameAr : product.nameEn;

  String _altProductName(BuildContext context) =>
      _isArabic(context) ? product.nameEn : product.nameAr;

  String _productDescription(BuildContext context) =>
      _isArabic(context) ? product.descriptionAr : product.descriptionEn;

  String _categoryName(BuildContext context) =>
      _isArabic(context) ? product.categoryNameAr : product.categoryNameEn;

  void _openEditWizard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ProductsCubit>()),
          BlocProvider.value(value: context.read<CategoriesCubit>()),
          BlocProvider.value(value: context.read<FlavorsCubit>()),
          BlocProvider(create: (_) => sl<ProductSizesCubit>()),
        ],
        child: ProductWizardDialog(existingProduct: product),
      ),
    );
  }

  void _confirmSoldOut(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const Icon(Icons.block, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              l10n.confirmSoldOutTitle,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Text(
          l10n.confirmSoldOutMessage(_productName(context)),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            icon: const Icon(Icons.block, size: 18),
            label: Text(l10n.soldOutAction),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProductsCubit>().archiveProduct(product.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _unSoldOut(BuildContext context) {
    context.read<ProductsCubit>().unArchiveProduct(product.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSoldOut = product.isArchived;

    return DashboardScaffold(
      pageTitle: _productName(context),
      pageSubtitle: _altProductName(context),
      pageIcon: Icons.cake,
      headerAction: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSoldOut)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.block, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    l10n.soldOutStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: l10n.productDetailsBack,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: BlocListener<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is ProductActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 350,
                          child: Column(
                            children: [
                              _buildImage(context),
                              const SizedBox(height: 16),
                              _buildActionButtons(context),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildBasicInfo(context),
                              const SizedBox(height: 16),
                              _buildSizesSection(context),
                              const SizedBox(height: 16),
                              _buildFlavorsSection(context),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildImage(context),
                        const SizedBox(height: 16),
                        _buildActionButtons(context),
                        const SizedBox(height: 16),
                        _buildBasicInfo(context),
                        const SizedBox(height: 16),
                        _buildSizesSection(context),
                        const SizedBox(height: 16),
                        _buildFlavorsSection(context),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final isSoldOut = product.isArchived;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Stack(
          children: [
            if (product.fullImageUrl != null)
              Image.network(
                product.fullImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                color: isSoldOut ? Colors.black.withValues(alpha: 0.4) : null,
                colorBlendMode: isSoldOut ? BlendMode.darken : null,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(Icons.broken_image, size: 80, color: AppColors.textHint),
                ),
              )
            else
              Container(
                color: AppColors.surfaceLight,
                child: const Icon(Icons.cake_outlined, size: 80, color: AppColors.textHint),
              ),
            if (isSoldOut)
              Center(
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Text(
                      context.l10n.soldOutStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final l10n = context.l10n;
    final isSoldOut = product.isArchived;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => _openEditWizard(context),
            icon: const Icon(Icons.edit),
            label: Text(l10n.editProduct),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.info,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 8),
          if (isSoldOut)
            ElevatedButton.icon(
              onPressed: () => _unSoldOut(context),
              icon: const Icon(Icons.check_circle),
              label: Text(l10n.enableProductForSale),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _confirmSoldOut(context),
              icon: const Icon(Icons.block),
              label: Text(l10n.markAsSoldOut),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _productName(context),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _altProductName(context),
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (product.isFeatured)
                _statusBadge(l10n.featuredLabel, AppColors.warning),
              if (product.isBestSeller)
                _statusBadge(l10n.bestSellerLabel, AppColors.accent),
              if (product.isCustomizable)
                _statusBadge(l10n.customizableLabel, AppColors.info),
              if (!product.isArchived)
                _statusBadge(l10n.availableStatus, AppColors.success)
              else
                _statusBadge(l10n.soldOutStatus, AppColors.error),
            ],
          ),
          const Divider(color: AppColors.border, height: 28),
          _detailRow(l10n.basePriceLabel, 'L.E ${product.basePrice.toStringAsFixed(2)}', icon: Icons.attach_money),
          _detailRow(l10n.categoryLabel, _categoryName(context), icon: Icons.category),
          const SizedBox(height: 12),
          Text(l10n.descriptionLabel, style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 4),
          Text(
            _productDescription(context),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSizesSection(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.straighten, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(l10n.availableSizesTitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${product.sizes.length}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (product.sizes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text(l10n.noSizesAdded, style: const TextStyle(color: AppColors.textHint))),
            )
          else
            ...product.sizes.map((s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      if (s.fullImageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            s.fullImageUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _sizePlaceholder(),
                          ),
                        )
                      else
                        _sizePlaceholder(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isArabic(context) ? s.nameAr : s.nameEn,
                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            if (s.sizeName != null)
                              Text(s.sizeName!, style: const TextStyle(color: AppColors.textHint, fontSize: 11)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                        child: Text(
                          'L.E ${s.price.toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }

  Widget _buildFlavorsSection(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_drink, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(l10n.availableFlavorsTitle, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${product.flavors.length}', style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (product.flavors.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text(l10n.noFlavorsAdded, style: const TextStyle(color: AppColors.textHint))),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.flavors.map((f) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isArabic(context) ? f.nameAr : f.nameEn,
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      if (f.extraPrice > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '+${f.extraPrice.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _sizePlaceholder() => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(6)),
        child: const Icon(Icons.straighten, color: AppColors.textHint, size: 18),
      );

  Widget _statusBadge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
      );

  Widget _detailRow(String label, String value, {IconData? icon}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.textHint),
              const SizedBox(width: 8),
            ],
            SizedBox(
              width: 100,
              child: Text('$label:', style: const TextStyle(color: AppColors.textHint, fontSize: 13)),
            ),
            Expanded(
              child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}
