import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../flavors/presentation/cubit/flavors_cubit.dart';
import '../../../product_sizes/presentation/cubit/product_sizes_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../cubit/products_cubit.dart';
import '../widgets/product_card.dart';
import '../widgets/product_wizard_dialog.dart';
import 'product_details_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _searchQuery = '';
  String _filter = 'all';

  bool get _isArabic => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductsCubit>().fetchAllProducts();
      final catState = context.read<CategoriesCubit>().state;
      if (catState is! CategoriesLoaded) {
        context.read<CategoriesCubit>().fetchAllCategories();
      }
      final flavState = context.read<FlavorsCubit>().state;
      if (flavState is! FlavorsLoaded) {
        context.read<FlavorsCubit>().fetchAllFlavors();
      }
    });
  }

  void _openAddWizard() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ProductsCubit>()),
          BlocProvider.value(value: context.read<CategoriesCubit>()),
          BlocProvider.value(value: context.read<FlavorsCubit>()),
          BlocProvider(create: (_) => sl<ProductSizesCubit>()),
        ],
        child: const ProductWizardDialog(),
      ),
    );
  }

  void _openEditWizard(ProductEntity product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ProductsCubit>()),
          BlocProvider.value(value: context.read<CategoriesCubit>()),
          BlocProvider.value(value: context.read<FlavorsCubit>()),
          BlocProvider(create: (_) => sl<ProductSizesCubit>()),
        ],
        child: ProductWizardDialog(existingProduct: product),
      ),
    );
  }

  void _openDetailsPage(ProductEntity product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<ProductsCubit>()),
            BlocProvider.value(value: context.read<CategoriesCubit>()),
            BlocProvider.value(value: context.read<FlavorsCubit>()),
          ],
          child: ProductDetailsPage(product: product),
        ),
      ),
    );
  }

  void _confirmSoldOut(ProductEntity product) {
    final l10n = context.l10n;
    final productName = _isArabic ? product.nameAr : product.nameEn;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Row(
          children: [
            const Icon(Icons.block, color: AppColors.error),
            const SizedBox(width: 8),
            Text(
              l10n.confirmSoldOutTitle,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        content: Text(
          l10n.confirmSoldOutMessage(productName),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            icon: const Icon(Icons.block, size: 18),
            label: Text(l10n.soldOutAction),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<ProductsCubit>().archiveProduct(product.id);
            },
          ),
        ],
      ),
    );
  }

  List<ProductEntity> _filterAndSortProducts(List<ProductEntity> products) {
    var list = products;

    if (_filter == 'active') {
      list = list.where((p) => !p.isArchived).toList();
    } else if (_filter == 'soldout') {
      list = list.where((p) => p.isArchived).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((p) {
        final name = _isArabic ? p.nameAr : p.nameEn;
        final category = _isArabic ? p.categoryNameAr : p.categoryNameEn;
        return name.toLowerCase().contains(q) ||
            category.toLowerCase().contains(q);
      }).toList();
    }

    final active = list.where((p) => !p.isArchived).toList();
    final soldOut = list.where((p) => p.isArchived).toList();
    return [...active, ...soldOut];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DashboardScaffold(
      pageTitle: l10n.productsPageTitle,
      pageSubtitle: l10n.productsPageSubtitle,
      pageIcon: Icons.cake,
      headerAction: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          int activeCount = 0;
          int soldOutCount = 0;
          if (state is ProductsLoaded) {
            activeCount = state.products.items.where((p) => !p.isArchived).length;
            soldOutCount = state.products.items.where((p) => p.isArchived).length;
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is ProductsLoaded) ...[
                _countBadge('$activeCount ${l10n.availableLabel}', AppColors.success),
                if (soldOutCount > 0) ...[
                  const SizedBox(width: 6),
                  _countBadge('$soldOutCount ${l10n.soldOutLabel}', AppColors.error),
                ],
              ],
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _openAddWizard,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.newProduct),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: MediaQuery.of(context).size.width < 700
          ? FloatingActionButton(
              onPressed: _openAddWizard,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocListener<ProductsCubit, ProductsState>(
        listener: (context, state) {
          if (state is ProductActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is ProductActionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Column(
          children: [
            _buildFiltersBar(context),
            Expanded(child: _buildProductsList(context)),
          ],
        ),
      ),
    );
  }

  Widget _countBadge(String text, Color color) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      );

  Widget _buildFiltersBar(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: l10n.productsSearchHint,
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButton<String>(
              value: _filter,
              underline: const SizedBox.shrink(),
              dropdownColor: AppColors.surfaceLight,
              style: const TextStyle(color: AppColors.textPrimary),
              icon: const Icon(Icons.filter_list, color: AppColors.textSecondary),
              items: [
                DropdownMenuItem(value: 'all', child: Text(l10n.allFilterProducts)),
                DropdownMenuItem(value: 'active', child: Text(l10n.activeOnlyFilter)),
                DropdownMenuItem(value: 'soldout', child: Text(l10n.soldOutOnlyFilter)),
              ],
              onChanged: (v) => setState(() => _filter = v ?? 'all'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProductsCubit, ProductsState>(
      builder: (context, state) {
        if (state is ProductsLoading || state is ProductsInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state is ProductsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                const SizedBox(height: 12),
                Text(state.message, style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<ProductsCubit>().fetchAllProducts(),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          );
        }
        if (state is ProductsLoaded) {
          final products = _filterAndSortProducts(state.products.items);
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox, size: 80, color: AppColors.textHint),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isNotEmpty
                        ? l10n.noMatchingResults
                        : (_filter == 'soldout' ? l10n.noSoldOutProducts : l10n.noProductsYet),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isEmpty && _filter != 'soldout')
                    ElevatedButton.icon(
                      onPressed: _openAddWizard,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addNewProduct),
                    ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => context.read<ProductsCubit>().fetchAllProducts(),
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;
                  if (constraints.maxWidth >= 1400) {
                    crossAxisCount = 5;
                  } else if (constraints.maxWidth >= 1100) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth >= 800) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth >= 500) {
                    crossAxisCount = 2;
                  } else {
                    crossAxisCount = 1;
                  }
                  return GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return ProductCard(
                        product: p,
                        onTap: () => _openDetailsPage(p),
                        onEdit: () => _openEditWizard(p),
                        onArchive: () => _confirmSoldOut(p),
                        onUnArchive: () => context.read<ProductsCubit>().unArchiveProduct(p.id),
                        onAssignFlavors: () => _openEditWizard(p),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
