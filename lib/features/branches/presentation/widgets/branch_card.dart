import 'package:flutter/material.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/branch_entity.dart';

class BranchCard extends StatelessWidget {
  final BranchEntity branch;
  final VoidCallback onEdit;
  final VoidCallback onArchive;
  final VoidCallback onUnArchive;
  final VoidCallback onTap;

  const BranchCard({
    super.key,
    required this.branch,
    required this.onEdit,
    required this.onArchive,
    required this.onUnArchive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final statusColor = branch.isArchived ? AppColors.error : AppColors.success;
    final statusLabel = branch.isArchived ? l10n.branchStatusClosed : l10n.branchStatusOpen;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: branch.isArchived
                ? AppColors.error.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      branch.isArchived ? Icons.store_mall_directory_outlined : Icons.store,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          branch.nameAr,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          branch.nameEn,
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _infoRow(Icons.phone, branch.phone),
              const SizedBox(height: 6),
              _infoRow(Icons.location_on_outlined, branch.addressAr),
              const SizedBox(height: 8),
              Text(
                branch.descriptionAr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              const Divider(height: 20, color: AppColors.border),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    color: AppColors.info,
                    tooltip: l10n.edit,
                    onPressed: onEdit,
                  ),
                  branch.isArchived
                      ? IconButton(
                          icon: const Icon(Icons.play_circle_outline, size: 20),
                          color: AppColors.success,
                          tooltip: l10n.reopenBranch,
                          onPressed: onUnArchive,
                        )
                      : IconButton(
                          icon: const Icon(Icons.pause_circle_outline, size: 20),
                          color: AppColors.error,
                          tooltip: l10n.pauseBranch,
                          onPressed: onArchive,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
