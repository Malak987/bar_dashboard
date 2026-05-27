import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1100;
    final isVerySmall = width < 600;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isVerySmall ? 8 : 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (isMobile)
            Builder(
              builder: (context) => IconButton(
                icon:
                const Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          if (!isVerySmall) ...[
            const Icon(Icons.store, color: AppColors.primary, size: 18),
            const SizedBox(width: 6),
            const Flexible(
              child: Text(
                'الفرع الرئيسي - وسط البلد',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const Spacer(),
          // Search (يظهر فقط في الشاشات الكبيرة)
          if (!isMobile)
            SizedBox(
              width: 220,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث...',
                  prefixIcon: const Icon(Icons.search, size: 18),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 12),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
            ),
          if (!isMobile) const SizedBox(width: 12),
          _IconBadge(icon: Icons.notifications_outlined, count: 3),
          if (!isVerySmall) ...[
            const SizedBox(width: 4),
            _IconBadge(icon: Icons.shopping_cart_outlined, count: 1),
          ],
          const SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: isVerySmall ? 6 : 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.person,
                      size: 14, color: Colors.white),
                ),
                if (!isVerySmall) ...[
                  const SizedBox(width: 8),
                  const Text('أحمد',
                      style: TextStyle(
                          color: AppColors.textPrimary, fontSize: 13)),
                  const Icon(Icons.arrow_drop_down,
                      color: AppColors.textSecondary, size: 18),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  const _IconBadge({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        if (count > 0)
          Positioned(
            right: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                  minWidth: 16, minHeight: 16),
              child: Text(
                '$count',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
