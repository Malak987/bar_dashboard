import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_entity.dart';

class CustomerListCard extends StatelessWidget {
  final UserEntity user;
  final int ordersCount;
  final double totalSpent;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomerListCard({
    super.key,
    required this.user,
    required this.ordersCount,
    required this.totalSpent,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBlocked = user.isArchived;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : isBlocked
                  ? AppColors.error.withValues(alpha: 0.5)
                  : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: _avatarColor(user.name).withValues(alpha: 0.2),
                          child: Text(
                            _initials(user.name),
                            style: TextStyle(
                              color: _avatarColor(user.name),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (isBlocked)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.surface, width: 2),
                              ),
                              child: const Icon(Icons.block, color: Colors.white, size: 9),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              color: isBlocked ? AppColors.textSecondary : AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              decoration: isBlocked ? TextDecoration.lineThrough : TextDecoration.none,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: const TextStyle(color: AppColors.textHint, fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isBlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          l10n.blocked,
                          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _miniStat(Icons.shopping_basket, '$ordersCount', l10n.orders, AppColors.info),
                    _miniStat(Icons.attach_money, 'L.E ${totalSpent.toStringAsFixed(0)}', l10n.totalPurchase, AppColors.success),
                    if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                      const Icon(Icons.phone, color: AppColors.primary, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniStat(IconData icon, String value, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 12),
        const SizedBox(width: 3),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11),
        ),
      ],
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0].characters.take(1).toString();
    return '${parts[0].characters.take(1).toString()}${parts[1].characters.take(1).toString()}';
  }

  Color _avatarColor(String name) {
    final colors = [
      AppColors.primary,
      AppColors.info,
      AppColors.accent,
      AppColors.warning,
      AppColors.success,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }
}
