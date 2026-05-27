import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
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
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Row(
          children: [
            Icon(Icons.block, color: AppColors.error),
            SizedBox(width: 8),
            Text('تأكيد Sold Out',
                style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
        content: Text(
          'هل تريد تحديد "${product.nameAr}" كـ Sold Out؟\n'
              'سيظهر للعملاء كمنتج غير متاح حالياً.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            icon: const Icon(Icons.block, size: 18),
            label: const Text('Sold Out'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProductsCubit>().archiveProduct(product.id);
              Navigator.of(context).pop(); // ارجع لصفحة المنتجات
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
    final isSoldOut = product.isArchived;

    return DashboardScaffold(
      pageTitle: product.nameAr,
      pageSubtitle: product.nameEn,
      pageIcon: Icons.cake,
      headerAction: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSoldOut)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.block, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('SOLD OUT',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ],
              ),
            ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'رجوع',
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
                  // اليمين: الصورة + الأزرار
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        _buildImage(),
                        const SizedBox(height: 16),
                        _buildActionButtons(context),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // الشمال: التفاصيل
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildBasicInfo(),
                        const SizedBox(height: 16),
                        _buildSizesSection(),
                        const SizedBox(height: 16),
                        _buildFlavorsSection(),
                      ],
                    ),
                  ),
                ],
              )
                  : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImage(),
                  const SizedBox(height: 16),
                  _buildActionButtons(context),
                  const SizedBox(height: 16),
                  _buildBasicInfo(),
                  const SizedBox(height: 16),
                  _buildSizesSection(),
                  const SizedBox(height: 16),
                  _buildFlavorsSection(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImage() {
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
                color: isSoldOut
                    ? Colors.black.withValues(alpha: 0.4)
                    : null,
                colorBlendMode: isSoldOut ? BlendMode.darken : null,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.surfaceLight,
                  child: const Icon(Icons.broken_image,
                      size: 80, color: AppColors.textHint),
                ),
              )
            else
              Container(
                color: AppColors.surfaceLight,
                child: const Icon(Icons.cake_outlined,
                    size: 80, color: AppColors.textHint),
              ),
            if (isSoldOut)
              Center(
                child: Transform.rotate(
                  angle: -0.2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: const Text(
                      'SOLD OUT',
                      style: TextStyle(
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
            label: const Text('تعديل المنتج'),
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
              label: const Text('إتاحة المنتج للبيع'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => _confirmSoldOut(context),
              icon: const Icon(Icons.block),
              label: const Text('تحديد كـ Sold Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo() {
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
          Text(product.nameAr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          Text(product.nameEn,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              )),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (product.isFeatured)
                _statusBadge('⭐ مميز', AppColors.warning),
              if (product.isBestSeller)
                _statusBadge('🔥 الأكثر مبيعاً', AppColors.accent),
              if (product.isCustomizable)
                _statusBadge('🎨 قابل للتخصيص', AppColors.info),
              if (!product.isArchived)
                _statusBadge('✅ متاح', AppColors.success)
              else
                _statusBadge('🚫 Sold Out', AppColors.error),
            ],
          ),
          const Divider(color: AppColors.border, height: 28),
          _detailRow('السعر الأساسي',
              'L.E ${product.basePrice.toStringAsFixed(2)}',
              icon: Icons.attach_money),
          _detailRow('الفئة', product.categoryNameAr,
              icon: Icons.category),
          const SizedBox(height: 12),
          const Text('الوصف:',
              style: TextStyle(
                  color: AppColors.textHint, fontSize: 13)),
          const SizedBox(height: 4),
          Text(product.descriptionAr,
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 14)),
          if (product.descriptionEn.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(product.descriptionEn,
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13)),
          ],
        ],
      ),
    );
  }

  Widget _buildSizesSection() {
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
              const Icon(Icons.straighten,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text('الأحجام المتاحة',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${product.sizes.length}',
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (product.sizes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('لا توجد أحجام مضافة',
                    style: TextStyle(color: AppColors.textHint)),
              ),
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
                        errorBuilder: (_, __, ___) =>
                            _sizePlaceholder(),
                      ),
                    )
                  else
                    _sizePlaceholder(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(s.nameAr,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14)),
                        if (s.sizeName != null)
                          Text(s.sizeName!,
                              style: const TextStyle(
                                  color: AppColors.textHint,
                                  fontSize: 11)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'L.E ${s.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildFlavorsSection() {
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
              const Icon(Icons.local_drink,
                  color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              const Text('النكهات المتاحة',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${product.flavors.length}',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (product.flavors.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('لا توجد نكهات مضافة',
                    style: TextStyle(color: AppColors.textHint)),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.flavors.map((f) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(f.nameAr,
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      if (f.extraPrice > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '+${f.extraPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold),
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
    decoration: BoxDecoration(
      color: AppColors.border,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Icon(Icons.straighten,
        color: AppColors.textHint, size: 18),
  );

  Widget _statusBadge(String text, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Text(text,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11)),
  );

  Widget _detailRow(String label, String value, {IconData? icon}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.textHint),
              const SizedBox(width: 8),
            ],
            SizedBox(
              width: 100,
              child: Text('$label:',
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 13)),
            ),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}
