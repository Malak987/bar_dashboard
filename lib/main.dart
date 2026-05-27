import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/routing/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/accounts/presentation/cubit/auth_cubit.dart';
import 'features/carts/presentation/cubit/cart_cubit.dart';
import 'features/categories/presentation/cubit/categories_cubit.dart';
import 'features/flavors/presentation/cubit/flavors_cubit.dart';
import 'features/orders/presentation/cubit/orders_cubit.dart';
import 'features/product_sizes/presentation/cubit/product_sizes_cubit.dart';
import 'features/products/presentation/cubit/products_cubit.dart';
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
        BlocProvider(create: (_) => di.sl<AuthCubit>()),
        BlocProvider(create: (_) => di.sl<CartCubit>()),
        BlocProvider(create: (_) => di.sl<CategoriesCubit>()),
        BlocProvider(create: (_) => di.sl<FlavorsCubit>()),
        BlocProvider(create: (_) => di.sl<OrdersCubit>()),
        BlocProvider(create: (_) => di.sl<ProductsCubit>()),
        BlocProvider(create: (_) => di.sl<ProductSizesCubit>()),
      ],
      child: MaterialApp(
        title: 'BAR Sweets - لوحة التحكم',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.onGenerateRoute,

        // ✅ Localization delegates (مهمة عشان TextField وكل widgets المادي)
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ar'),
          Locale('en'),
        ],
        locale: const Locale('ar'),

        // ✅ RTL على مستوى التطبيق كله
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          );
        },
      ),
    );
  }
}
