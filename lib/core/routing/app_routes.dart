import 'package:flutter/material.dart';
import '../../features/accounts/presentation/pages/customers_page.dart';
import '../../features/accounts/presentation/pages/login_page.dart';
import '../../features/accounts/presentation/pages/register_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/coming_soon/presentation/pages/coming_soon_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/flavors/presentation/pages/flavors_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';

class AppRoutes {
  // Auth
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Main
  static const String dashboard = '/dashboard';

  // Pages
  static const String products = '/products';
  static const String categories = '/categories';
  static const String orders = '/orders';
  static const String flavors = '/flavors';
  static const String inventory = '/inventory';
  static const String customers = '/customers';
  static const String employees = '/employees';
  static const String coupons = '/coupons';
  static const String reports = '/reports';
  static const String analytics = '/analytics';
  static const String branches = '/branches';
  static const String notifications = '/notifications';
  static const String activityLog = '/activity-log';
  static const String settings = '/settings';
  static const String addEmployee = '/add-employee';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
    // ===== Auth =====
      case splash:
        return _route(const SplashPage(), settings);
      case login:
        return _route(const LoginPage(), settings);
      case register:
        return _route(const RegisterPage(isAdminMode: false), settings);
      case addEmployee:
        return _route(const RegisterPage(isAdminMode: true), settings);

    // ===== Main =====
      case dashboard:
        return _route(const DashboardPage(), settings);

    // ===== Implemented Pages =====
      case products:
        return _route(const ProductsPage(), settings);
      case categories:
        return _route(const CategoriesPage(), settings);
      case orders:
        return _route(const OrdersPage(), settings);
      case customers:
        return _route(const CustomersPage(), settings);

    // ===== Coming Soon =====
      case flavors:
        return _route(const FlavorsPage(), settings);
      case inventory:
        return _route(
            const ComingSoonPage(pageName: 'المخزون', icon: Icons.inventory_2),
            settings);
      case employees:
        return _route(
            const ComingSoonPage(pageName: 'الموظفين', icon: Icons.badge),
            settings);
      case coupons:
        return _route(
            const ComingSoonPage(pageName: 'الكوبونات', icon: Icons.discount),
            settings);
      case reports:
        return _route(
            const ComingSoonPage(pageName: 'التقارير', icon: Icons.assessment),
            settings);
      case analytics:
        return _route(
            const ComingSoonPage(pageName: 'التحليلات', icon: Icons.analytics),
            settings);
      case branches:
        return _route(
            const ComingSoonPage(pageName: 'الفروع', icon: Icons.store),
            settings);
      case notifications:
        return _route(
            const ComingSoonPage(
                pageName: 'الإشعارات', icon: Icons.notifications),
            settings);
      case activityLog:
        return _route(
            const ComingSoonPage(pageName: 'سجل النشاط', icon: Icons.history),
            settings);
      case AppRoutes.settings:
        return _route(
            const ComingSoonPage(pageName: 'الإعدادات', icon: Icons.settings),
            settings);

      default:
        return _route(
          const Scaffold(
            body: Center(child: Text('404 - Page Not Found')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _route(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}