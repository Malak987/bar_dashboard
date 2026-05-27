import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onUnArchive;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onEdit,
    required this.onArchive,
    required this.onUnArchive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: category.isArchived
                ? AppColors.error.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: category.fullImageUrl != null
                        ? Image.network(
                      category.fullImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                      loadingBuilder: (_, child, p) => p == null
                          ? child
                          : Container(
                          color: AppColors.surfaceLight,
                          child: const Center(
                              child:
                              CircularProgressIndicator(
                                  color:
                                  AppColors.primary))),
                    )
                        : _placeholder(),
                  ),
                ),
                if (category.isArchived)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('📦 مؤرشفة',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2,
                            color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text('${category.productsCount} منتج',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.nameAr,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(category.nameEn,
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(category.descriptionAr,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        color: AppColors.info,
                        tooltip: 'تعديل',
                        onPressed: onEdit,
                      ),
                      category.isArchived
                          ? IconButton(
                        icon: const Icon(Icons.unarchive, size: 18),
                        color: AppColors.success,
                        tooltip: 'إلغاء الأرشفة',
                        onPressed: onUnArchive,
                      )
                          : IconButton(
                        icon: const Icon(Icons.archive, size: 18),
                        color: AppColors.error,
                        tooltip: 'أرشفة',
                        onPressed: onArchive,
                      ),
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
    child: const Icon(Icons.category_outlined,
        size: 50, color: AppColors.textHint),
  );
}
