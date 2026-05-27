import 'package:flutter/material.dart';
import '../../features/dashboard/presentation/widgets/dashboard_header.dart';
import '../../features/dashboard/presentation/widgets/dashboard_sidebar.dart';
import '../theme/app_colors.dart';

/// Scaffold مشترك لكل صفحات الداشبورد
/// Sidebar + Header دايماً ظاهرين في كل الصفحات
class DashboardScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// عنوان الصفحة (هيظهر في الـ Header)
  final String? pageTitle;
  final String? pageSubtitle;
  final IconData? pageIcon;

  /// زر أكشن إضافي في الـ Header (زي زر "إضافة")
  final Widget? headerAction;

  const DashboardScaffold({
    super.key,
    required this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.pageTitle,
    this.pageSubtitle,
    this.pageIcon,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;

    return Scaffold(
      backgroundColor: AppColors.background,
      // الـ drawer للموبايل فقط
      drawer: !isDesktop ? const Drawer(child: DashboardSidebar()) : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: SafeArea(
        child: Row(
          children: [
            // ✅ Sidebar دايماً ظاهر على الديسكتوب
            if (isDesktop)
              const SizedBox(
                width: 240,
                child: DashboardSidebar(),
              ),
            // ✅ Header + Page Title + Body
            Expanded(
              child: Column(
                children: [
                  const DashboardHeader(),
                  if (pageTitle != null) _buildPageTitleBar(context),
                  Expanded(child: body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitleBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (pageIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(pageIcon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pageTitle!,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (pageSubtitle != null)
                  Text(
                    pageSubtitle!,
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
              ],
            ),
          ),
          if (headerAction != null) headerAction!,
        ],
      ),
    );
  }
}
