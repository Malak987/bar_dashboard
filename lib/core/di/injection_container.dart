import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_constants.dart';
import '../network/dio_factory.dart';
import '../storage/auth_local_storage.dart';

// Accounts
import '../../features/accounts/data/datasources/accounts_web_service.dart';
import '../../features/accounts/data/repositories/accounts_repository_impl.dart';
import '../../features/accounts/domain/repositories/accounts_repository.dart';
import '../../features/accounts/domain/usecases/admin_login_usecase.dart';
import '../../features/accounts/domain/usecases/get_all_users_usecase.dart';
import '../../features/accounts/domain/usecases/get_user_by_id_usecase.dart';
import '../../features/accounts/domain/usecases/register_admin_usecase.dart';
import '../../features/accounts/domain/usecases/update_user_archive_status_usecase.dart';
import '../../features/accounts/presentation/cubit/auth_cubit.dart';
import '../../features/accounts/presentation/cubit/users_cubit.dart';

// Carts
import '../../features/carts/data/datasources/carts_web_service.dart';
import '../../features/carts/data/repositories/carts_repository_impl.dart';
import '../../features/carts/domain/repositories/carts_repository.dart';
import '../../features/carts/domain/usecases/add_to_cart_usecase.dart';
import '../../features/carts/domain/usecases/clear_cart_usecase.dart';
import '../../features/carts/domain/usecases/get_cart_usecase.dart';
import '../../features/carts/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/carts/domain/usecases/update_cart_item_quantity_usecase.dart';
import '../../features/carts/presentation/cubit/cart_cubit.dart';

// Categories
import '../../features/categories/data/datasources/categories_web_service.dart';
import '../../features/categories/data/repositories/categories_repository_impl.dart';
import '../../features/categories/domain/repositories/categories_repository.dart';
import '../../features/categories/domain/usecases/add_category_usecase.dart';
import '../../features/categories/domain/usecases/archive_category_usecase.dart';
import '../../features/categories/domain/usecases/get_all_categories_usecase.dart';
import '../../features/categories/domain/usecases/get_category_by_id_usecase.dart';
import '../../features/categories/domain/usecases/update_category_usecase.dart';
import '../../features/categories/presentation/cubit/categories_cubit.dart';

// Flavors
import '../../features/flavors/data/datasources/flavors_web_service.dart';
import '../../features/flavors/data/repositories/flavors_repository_impl.dart';
import '../../features/flavors/domain/repositories/flavors_repository.dart';
import '../../features/flavors/domain/usecases/flavors_usecases.dart';
import '../../features/flavors/presentation/cubit/flavors_cubit.dart';

// Orders
import '../../features/orders/data/datasources/orders_web_service.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/orders_usecases.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

// Products
import '../../features/products/data/datasources/products_web_service.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/usecases/products_usecases.dart';
import '../../features/products/presentation/cubit/products_cubit.dart';

// ProductSizes
import '../../features/product_sizes/data/datasources/product_sizes_web_service.dart';
import '../../features/product_sizes/data/repositories/product_sizes_repository_impl.dart';
import '../../features/product_sizes/domain/repositories/product_sizes_repository.dart';
import '../../features/product_sizes/domain/usecases/product_sizes_usecases.dart';
import '../../features/product_sizes/presentation/cubit/product_sizes_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ===== Core =====
  final sharedPrefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton<AuthLocalStorage>(() => AuthLocalStorage(sl()));

  final dio = DioFactory.create(sl<AuthLocalStorage>());
  sl.registerLazySingleton(() => dio);

  // ===== Accounts =====
  sl.registerLazySingleton<AccountsWebService>(
        () => AccountsWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<AccountsRepository>(
        () => AccountsRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => AdminLoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterAdminUseCase(sl()));
  sl.registerLazySingleton(() => GetAllUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserArchiveStatusUseCase(sl()));
  sl.registerFactory(() => AuthCubit(sl(), sl(), sl()));
  sl.registerFactory(() => UsersCubit(sl(), sl(), sl()));

  // ===== Carts =====
  sl.registerLazySingleton<CartsWebService>(
        () => CartsWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<CartsRepository>(() => CartsRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCartItemQuantityUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerFactory(() => CartCubit(sl(), sl(), sl(), sl(), sl()));

  // ===== Categories =====
  sl.registerLazySingleton<CategoriesWebService>(
        () => CategoriesWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<CategoriesRepository>(
        () => CategoriesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAllCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoryByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => ArchiveCategoryUseCase(sl()));
  sl.registerLazySingleton(() => UnArchiveCategoryUseCase(sl()));
  sl.registerFactory(
        () => CategoriesCubit(sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // ===== Flavors =====
  sl.registerLazySingleton<FlavorsWebService>(
        () => FlavorsWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<FlavorsRepository>(
        () => FlavorsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAllFlavorsUseCase(sl()));
  sl.registerLazySingleton(() => GetFlavorByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddFlavorUseCase(sl()));
  sl.registerLazySingleton(() => UpdateFlavorUseCase(sl()));
  sl.registerLazySingleton(() => ArchiveFlavorUseCase(sl()));
  sl.registerLazySingleton(() => UnArchiveFlavorUseCase(sl()));
  sl.registerFactory(() => FlavorsCubit(sl(), sl(), sl(), sl(), sl(), sl()));

  // ===== Orders =====
  sl.registerLazySingleton<OrdersWebService>(
        () => OrdersWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<OrdersRepository>(
        () => OrdersRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetMyOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetAllOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderByIdUseCase(sl()));
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));
  sl.registerFactory(() => OrdersCubit(sl(), sl(), sl(), sl(), sl(), sl()));

  // ===== Products =====
  sl.registerLazySingleton<ProductsWebService>(
        () => ProductsWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<ProductsRepository>(
        () => ProductsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetAllProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => ArchiveProductUseCase(sl()));
  sl.registerLazySingleton(() => UnArchiveProductUseCase(sl()));
  sl.registerLazySingleton(() => AssignFlavorsToProductUseCase(sl()));
  sl.registerFactory(
        () => ProductsCubit(sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // ===== ProductSizes =====
  sl.registerLazySingleton<ProductSizesWebService>(
        () => ProductSizesWebService(sl(), baseUrl: ApiConstants.baseUrl),
  );
  sl.registerLazySingleton<ProductSizesRepository>(
        () => ProductSizesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProductSizesUseCase(sl()));
  sl.registerLazySingleton(() => AddProductSizeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductSizeUseCase(sl()));
  sl.registerLazySingleton(() => ArchiveProductSizeUseCase(sl()));
  sl.registerFactory(
        () => ProductSizesCubit(sl(), sl(), sl(), sl()),
  );
}