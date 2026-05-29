import 'package:flutter/material.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/flavor_entity.dart';

class FlavorCard extends StatelessWidget {
  final FlavorEntity flavor;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onUnArchive;
  final VoidCallback onTap;

  const FlavorCard({
    super.key,
    required this.flavor,
    required this.onEdit,
    required this.onArchive,
    required this.onUnArchive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final flavorName = isArabic ? flavor.nameAr : flavor.nameEn;
    final description = isArabic ? flavor.descriptionAr : flavor.descriptionEn;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: flavor.isArchived
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: flavor.fullImageUrl != null
                        ? Image.network(
                            flavor.fullImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _placeholder(),
                            loadingBuilder: (_, child, p) => p == null
                                ? child
                                : Container(
                                    color: AppColors.surfaceLight,
                                    child: const Center(
                                      child: CircularProgressIndicator(color: AppColors.primary),
                                    ),
                                  ),
                          )
                        : _placeholder(),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (flavor.isArchived)
                        _badge(l10n.flavorArchivedBadge, AppColors.error)
                      else if (!flavor.isAvailable)
                        _badge(l10n.flavorUnavailableBadge, AppColors.warning)
                      else
                        _badge(l10n.flavorAvailableBadge, AppColors.success),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flavorName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isArabic ? flavor.nameEn : flavor.nameAr,
                    style: const TextStyle(color: AppColors.textHint, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        color: AppColors.info,
                        tooltip: l10n.edit,
                        onPressed: onEdit,
                      ),
                      flavor.isArchived
                          ? IconButton(
                              icon: const Icon(Icons.unarchive, size: 18),
                              color: AppColors.success,
                              tooltip: l10n.archiveAction,
                              onPressed: onUnArchive,
                            )
                          : IconButton(
                              icon: const Icon(Icons.archive, size: 18),
                              color: AppColors.error,
                              tooltip: l10n.archiveAction,
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
        child: const Icon(Icons.local_drink_outlined, size: 50, color: AppColors.textHint),
      );

  Widget _badge(String label, Color color) => Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
