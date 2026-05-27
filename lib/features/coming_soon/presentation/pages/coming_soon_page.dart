import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';

class ComingSoonPage extends StatelessWidget {
  final String pageName;
  final IconData icon;

  const ComingSoonPage({
    super.key,
    required this.pageName,
    this.icon = Icons.construction,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      pageTitle: pageName,
      pageSubtitle: 'قيد التطوير',
      pageIcon: icon,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                pageName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '🚧 قيد التطوير 🚧',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'هذه الصفحة لا تزال قيد الإنشاء.\nسنقوم بإضافتها قريباً.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
