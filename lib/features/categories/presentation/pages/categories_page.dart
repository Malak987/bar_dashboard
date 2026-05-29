import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../domain/entities/category_entity.dart';
import '../cubit/categories_cubit.dart';
import '../widgets/category_card.dart';
import '../widgets/category_form_dialog.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _searchQuery = '';
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesCubit>().fetchAllCategories();
    });
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoriesCubit>(),
        child: const CategoryFormDialog(),
      ),
    );
  }

  void _openEditDialog(CategoryEntity category) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoriesCubit>(),
        child: CategoryFormDialog(category: category),
      ),
    );
  }

  void _confirmArchive(CategoryEntity category) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.confirmArchiveTitle,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          l10n.categoryArchiveMessage(category.nameAr, category.productsCount),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<CategoriesCubit>().archiveCategory(category.id);
            },
            child: Text(l10n.archiveAction),
          ),
        ],
      ),
    );
  }

  List<CategoryEntity> _filterCategories(List<CategoryEntity> items) {
    var list = items;
    if (_filter == 'active') {
      list = list.where((c) => !c.isArchived).toList();
    } else if (_filter == 'archived') {
      list = list.where((c) => c.isArchived).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((c) =>
              c.nameAr.toLowerCase().contains(q) ||
              c.nameEn.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DashboardScaffold(
      pageTitle: l10n.categories,
      pageSubtitle: l10n.categoriesPageSubtitle,
      pageIcon: Icons.category,
      headerAction: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state is CategoriesLoaded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${state.categories.totalCount} ${l10n.categoriesCountLabel}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _openAddDialog,
                icon: const Icon(Icons.add, size: 18),
                label: Text(l10n.newCategory),
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
              onPressed: _openAddDialog,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add),
            )
          : null,
      body: BlocListener<CategoriesCubit, CategoriesState>(
        listener: (context, state) {
          if (state is CategoryActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is CategoryActionFailure) {
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
            Expanded(child: _buildCategoriesList(context)),
          ],
        ),
      ),
    );
  }

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
                hintText: l10n.searchCategoryHint,
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
                DropdownMenuItem(value: 'all', child: Text(l10n.allFilter)),
                DropdownMenuItem(value: 'active', child: Text(l10n.activeCategoriesFilter)),
                DropdownMenuItem(value: 'archived', child: Text(l10n.archivedCategoriesFilter)),
              ],
              onChanged: (v) => setState(() => _filter = v ?? 'all'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading || state is CategoriesInitial) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is CategoriesFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                const SizedBox(height: 12),
                Text(state.message, style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<CategoriesCubit>().fetchAllCategories(),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is CategoriesLoaded) {
          final categories = _filterCategories(state.categories.items);

          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.category_outlined, size: 80, color: AppColors.textHint),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isNotEmpty
                        ? l10n.noMatchingResults
                        : (_filter == 'archived'
                            ? l10n.noArchivedCategories
                            : l10n.noCategoriesAvailable),
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isEmpty)
                    ElevatedButton.icon(
                      onPressed: _openAddDialog,
                      icon: const Icon(Icons.add),
                      label: Text(l10n.newCategory),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<CategoriesCubit>().fetchAllCategories(),
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
                      childAspectRatio: 0.85,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (_, i) {
                      final c = categories[i];
                      return CategoryCard(
                        category: c,
                        onTap: () => _openEditDialog(c),
                        onEdit: () => _openEditDialog(c),
                        onArchive: () => _confirmArchive(c),
                        onUnArchive: () => context.read<CategoriesCubit>().unArchiveCategory(c.id),
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
