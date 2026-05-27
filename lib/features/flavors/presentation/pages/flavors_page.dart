import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../domain/entities/flavor_entity.dart';
import '../cubit/flavors_cubit.dart';
import '../widgets/flavor_card.dart';
import '../widgets/flavor_form_dialog.dart';

class FlavorsPage extends StatefulWidget {
  const FlavorsPage({super.key});

  @override
  State<FlavorsPage> createState() => _FlavorsPageState();
}

class _FlavorsPageState extends State<FlavorsPage> {
  String _searchQuery = '';
  String _filter = 'all'; // all / available / unavailable / archived

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FlavorsCubit>().fetchAllFlavors();
    });
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<FlavorsCubit>(),
        child: const FlavorFormDialog(),
      ),
    );
  }

  void _openEditDialog(FlavorEntity flavor) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<FlavorsCubit>(),
        child: FlavorFormDialog(flavor: flavor),
      ),
    );
  }

  void _confirmArchive(FlavorEntity flavor) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('تأكيد الأرشفة',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'هل أنت متأكد من أرشفة نكهة "${flavor.nameAr}"؟',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<FlavorsCubit>().archiveFlavor(flavor.id);
            },
            child: const Text('أرشفة'),
          ),
        ],
      ),
    );
  }

  /// الترتيب: النكهات المتاحة أولاً، ثم غير المتاحة، ثم المؤرشفة
  List<FlavorEntity> _filterAndSort(List<FlavorEntity> items) {
    var list = items;

    if (_filter == 'available') {
      list =
          list.where((f) => !f.isArchived && f.isAvailable).toList();
    } else if (_filter == 'unavailable') {
      list =
          list.where((f) => !f.isArchived && !f.isAvailable).toList();
    } else if (_filter == 'archived') {
      list = list.where((f) => f.isArchived).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((f) =>
      f.nameAr.toLowerCase().contains(q) ||
          f.nameEn.toLowerCase().contains(q))
          .toList();
    }

    // الترتيب: متاح → غير متاح → مؤرشف
    final available =
    list.where((f) => !f.isArchived && f.isAvailable).toList();
    final unavailable =
    list.where((f) => !f.isArchived && !f.isAvailable).toList();
    final archived = list.where((f) => f.isArchived).toList();
    return [...available, ...unavailable, ...archived];
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScaffold(
      pageTitle: 'النكهات',
      pageSubtitle: 'إدارة نكهات المنتجات',
      pageIcon: Icons.local_drink,
      headerAction: BlocBuilder<FlavorsCubit, FlavorsState>(
        buildWhen: (_, c) => c is FlavorsLoaded,
        builder: (context, state) {
          int available = 0;
          int archived = 0;
          if (state is FlavorsLoaded) {
            available = state.flavors.items
                .where((f) => !f.isArchived && f.isAvailable)
                .length;
            archived =
                state.flavors.items.where((f) => f.isArchived).length;
          }
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _countBadge('$available متاحة', AppColors.success),
              if (archived > 0) ...[
                const SizedBox(width: 6),
                _countBadge('$archived مؤرشفة', AppColors.error),
              ],
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _openAddDialog,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('نكهة جديدة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: MediaQuery.of(context).size.width < 700
          ? FloatingActionButton(
        onPressed: _openAddDialog,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add),
      )
          : null,
      body: BlocListener<FlavorsCubit, FlavorsState>(
        listener: (context, state) {
          if (state is FlavorActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is FlavorActionFailure) {
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
            _buildFiltersBar(),
            Expanded(child: _buildFlavorsList()),
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
    child: Text(text,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 11)),
  );

  Widget _buildFiltersBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن نكهة...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 12),
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
              icon: const Icon(Icons.filter_list,
                  color: AppColors.textSecondary),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('الكل')),
                DropdownMenuItem(
                    value: 'available', child: Text('المتاحة')),
                DropdownMenuItem(
                    value: 'unavailable', child: Text('غير المتاحة')),
                DropdownMenuItem(
                    value: 'archived', child: Text('المؤرشفة')),
              ],
              onChanged: (v) => setState(() => _filter = v ?? 'all'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlavorsList() {
    return BlocBuilder<FlavorsCubit, FlavorsState>(
      buildWhen: (prev, current) {
        if (current is FlavorsLoading && prev is FlavorsLoaded) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is FlavorsLoading || state is FlavorsInitial) {
          return const Center(
              child:
              CircularProgressIndicator(color: AppColors.accent));
        }

        if (state is FlavorsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline,
                    size: 60, color: AppColors.error),
                const SizedBox(height: 12),
                Text(state.message,
                    style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<FlavorsCubit>().fetchAllFlavors(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state is FlavorsLoaded) {
          final flavors = _filterAndSort(state.flavors.items);

          if (flavors.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_drink_outlined,
                      size: 80, color: AppColors.textHint),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'لا توجد نتائج مطابقة'
                        : (_filter == 'archived'
                        ? 'لا توجد نكهات مؤرشفة'
                        : _filter == 'unavailable'
                        ? 'كل النكهات متاحة 👍'
                        : 'لا توجد نكهات بعد'),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isEmpty && _filter != 'archived')
                    ElevatedButton.icon(
                      onPressed: _openAddDialog,
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة نكهة جديدة'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<FlavorsCubit>().silentRefreshAllFlavors(),
            color: AppColors.accent,
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
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: flavors.length,
                    itemBuilder: (_, i) {
                      final f = flavors[i];
                      return FlavorCard(
                        flavor: f,
                        onTap: () => _openEditDialog(f),
                        onEdit: () => _openEditDialog(f),
                        onArchive: () => _confirmArchive(f),
                        onUnArchive: () => context
                            .read<FlavorsCubit>()
                            .unArchiveFlavor(f.id),
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
