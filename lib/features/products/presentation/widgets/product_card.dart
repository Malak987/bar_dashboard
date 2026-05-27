import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/product_entity.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onUnArchive;
  final VoidCallback onAssignFlavors;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onArchive,
    required this.onUnArchive,
    required this.onAssignFlavors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSoldOut = product.isArchived;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSoldOut
                ? AppColors.error.withValues(alpha: 0.6)
                : AppColors.border,
            width: isSoldOut ? 1.5 : 1,
          ),
          boxShadow: isSoldOut
              ? null
              : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Image =====
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: product.fullImageUrl != null
                        ? Image.network(
                      product.fullImageUrl!,
                      fit: BoxFit.cover,
                      color: isSoldOut
                          ? Colors.black.withValues(alpha: 0.5)
                          : null,
                      colorBlendMode:
                      isSoldOut ? BlendMode.darken : null,
                      errorBuilder: (_, __, ___) => _placeholder(),
                      loadingBuilder: (_, child, progress) =>
                      progress == null
                          ? child
                          : Container(
                        color: AppColors.surfaceLight,
                        child: const Center(
                            child:
                            CircularProgressIndicator(
                                color: AppColors
                                    .primary)),
                      ),
                    )
                        : _placeholder(),
                  ),
                ),

                // 🔴 SOLD OUT Big Overlay
                if (isSoldOut)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Center(
                          child: Transform.rotate(
                            angle: -0.2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'SOLD OUT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Badges العلوية
                if (!isSoldOut)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (product.isFeatured)
                          _badge('⭐ مميز', AppColors.warning),
                        if (product.isBestSeller)
                          _badge('🔥 الأكثر مبيعاً', AppColors.accent),
                        if (product.isCustomizable)
                          _badge('🎨 قابل للتخصيص', AppColors.info),
                      ],
                    ),
                  ),

                // Price badge
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSoldOut
                          ? AppColors.textHint
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'L.E ${product.basePrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ===== Body =====
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nameAr,
                    style: TextStyle(
                      color: isSoldOut
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      decoration: isSoldOut
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.category,
                          size: 12, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          product.categoryNameAr,
                          style: const TextStyle(
                              color: AppColors.textHint, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (product.descriptionAr.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      product.descriptionAr,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: [
                      if (product.sizes.isNotEmpty)
                        _miniChip(
                            '${product.sizes.length} حجم',
                            Icons.straighten,
                            AppColors.info),
                      if (product.flavors.isNotEmpty)
                        _miniChip(
                            '${product.flavors.length} نكهة',
                            Icons.local_drink,
                            AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _iconBtn(Icons.edit, AppColors.info, 'تعديل', onEdit),
                      isSoldOut
                          ? _iconBtn(Icons.check_circle,
                          AppColors.success, 'إتاحة المنتج',
                          onUnArchive)
                          : _iconBtn(Icons.block, AppColors.error,
                          'Sold Out', onArchive),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    color: AppColors.surfaceLight,
    child: const Icon(Icons.cake_outlined,
        size: 50, color: AppColors.textHint),
  );

  Widget _badge(String label, Color color) => Container(
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(label,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold)),
  );

  Widget _miniChip(String text, IconData icon, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 3),
        Text(text,
            style: TextStyle(
                color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    ),
  );

  Widget _iconBtn(
      IconData icon, Color color, String tooltip, VoidCallback onTap) =>
      IconButton(
        icon: Icon(icon, size: 18),
        color: color,
        tooltip: tooltip,
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        padding: EdgeInsets.zero,
      );
}
