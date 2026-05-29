import 'package:dashboard_bar/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 import 'core/branch_selection/branch_selection_cubit.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_event_listener.dart';
import 'features/accounts/presentation/cubit/auth_cubit.dart';
import 'features/accounts/presentation/cubit/users_cubit.dart';
import 'features/activity_log/presentation/cubit/activity_log_cubit.dart';
import 'features/branches/presentation/cubit/branches_cubit.dart';
import 'features/carts/presentation/cubit/cart_cubit.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/flavors/presentation/cubit/flavors_cubit.dart';
import 'features/notifications/presentation/cubit/notification_center_cubit.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/product_sizes/presentation/cubit/product_sizes_cubit.dart';
import 'features/products/presentation/cubit/products_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BranchSelectionCubit()),
        BlocProvider(create: (_) => NotificationCenterCubit()),
        BlocProvider(create: (_) => ActivityLogCubit()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()..loadSettings()),
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<UsersCubit>()),
        BlocProvider(create: (_) => di.sl<BranchesCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()),
        BlocProvider(create: (_) => di.sl<CategoriesCubit>()),
        BlocProvider(create: (_) => di.sl<FlavorsCubit>()),
        BlocProvider(create: (_) => di.sl<OrdersCubit>()),
        BlocProvider(create: (_) => di.sl<ProductsCubit>()),
        BlocProvider(create: (_) => di.sl<ProductSizesCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          final locale = Locale(settingsState.localeCode);
          final isArabic = settingsState.isArabic;

          return MaterialApp(
            title: 'BAR Sweets',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            builder: (context, child) {
              return Directionality(
                textDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                child: AppEventListener(child: child!),
              );
            },
          );
        },
      ),
    );
  }
}
