import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dashboard_scaffold.dart';
import '../../domain/entities/branch_entity.dart';
import '../cubit/branches_cubit.dart';
import '../widgets/branch_card.dart';
import '../widgets/branch_form_dialog.dart';

class BranchesPage extends StatefulWidget {
  const BranchesPage({super.key});

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  String _searchQuery = '';
  String _filter = 'all'; // all / open / closed

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BranchesCubit>().fetchAllBranches();
    });
  }

  void _openAddDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<BranchesCubit>(),
        child: const BranchFormDialog(),
      ),
    );
  }

  void _openEditDialog(BranchEntity branch) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BlocProvider.value(
        value: context.read<BranchesCubit>(),
        child: BranchFormDialog(branch: branch),
      ),
    );
  }

  void _confirmArchive(BranchEntity branch) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          l10n.branchArchiveTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          l10n.branchArchiveMessage(branch.nameAr),
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
              context.read<BranchesCubit>().archiveBranch(branch.id);
            },
            child: Text(l10n.closeBranch),
          ),
        ],
      ),
    );
  }

  List<BranchEntity> _filterAndSort(List<BranchEntity> items) {
    var list = items;

    if (_filter == 'open') {
      list = list.where((b) => !b.isArchived).toList();
    } else if (_filter == 'closed') {
      list = list.where((b) => b.isArchived).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((b) {
        return b.nameAr.toLowerCase().contains(q) ||
            b.nameEn.toLowerCase().contains(q) ||
            b.phone.toLowerCase().contains(q) ||
            b.addressAr.toLowerCase().contains(q);
      }).toList();
    }

    final open = list.where((b) => !b.isArchived).toList();
    final closed = list.where((b) => b.isArchived).toList();
    return [...open, ...closed];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DashboardScaffold(
      pageTitle: l10n.branches,
      pageSubtitle: l10n.branchesPageSubtitle,
      pageIcon: Icons.store,
      headerAction: BlocBuilder<BranchesCubit, BranchesState>(
        buildWhen: (_, current) => current is BranchesLoaded,
        builder: (context, state) {
          int openCount = 0;
          int closedCount = 0;
          if (state is BranchesLoaded) {
            openCount = state.branches.items.where((b) => !b.isArchived).length;
            closedCount = state.branches.items.where((b) => b.isArchived).length;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _countBadge('$openCount ${l10n.openBranchesShortLabel}', AppColors.success),
              if (closedCount > 0) ...[
                const SizedBox(width: 6),
                _countBadge('$closedCount ${l10n.closedBranchesShortLabel}', AppColors.error),
              ],
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _openAddDialog,
                icon: const Icon(Icons.add_business, size: 18),
                label: Text(l10n.newBranch),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.info,
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: MediaQuery.of(context).size.width < 700
          ? FloatingActionButton(
              onPressed: _openAddDialog,
              backgroundColor: AppColors.info,
              child: const Icon(Icons.add_business),
            )
          : null,
      body: BlocListener<BranchesCubit, BranchesState>(
        listener: (context, state) {
          if (state is BranchActionSuccess) {
            if (_filter != 'all') {
              setState(() => _filter = 'all');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is BranchActionFailure) {
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
            Expanded(child: _buildBranchesList()),
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

  Widget _buildFiltersBar() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: l10n.branchesSearchHint,
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
                DropdownMenuItem(value: 'all', child: Text(l10n.allBranchesFilter)),
                DropdownMenuItem(value: 'open', child: Text(l10n.openBranchesFilter)),
                DropdownMenuItem(value: 'closed', child: Text(l10n.closedBranchesFilter)),
              ],
              onChanged: (v) => setState(() => _filter = v ?? 'all'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchesList() {
    final l10n = context.l10n;
    return BlocBuilder<BranchesCubit, BranchesState>(
      buildWhen: (prev, current) {
        if (current is BranchActionLoading ||
            current is BranchActionSuccess ||
            current is BranchActionFailure) {
          return false;
        }
        if (current is BranchesLoading && prev is BranchesLoaded) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state is BranchesLoading || state is BranchesInitial) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.info),
          );
        }

        if (state is BranchesFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: AppColors.error),
                const SizedBox(height: 12),
                Text(state.message, style: const TextStyle(color: AppColors.error)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<BranchesCubit>().fetchAllBranches(),
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.retry),
                ),
              ],
            ),
          );
        }

        if (state is BranchesLoaded) {
          final branches = _filterAndSort(state.branches.items);

          if (branches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.store_outlined, size: 80, color: AppColors.textHint),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isNotEmpty
                        ? l10n.noMatchingBranches
                        : (_filter == 'closed'
                            ? l10n.noClosedBranches
                            : l10n.noBranchesYet),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_searchQuery.isEmpty)
                    ElevatedButton.icon(
                      onPressed: _openAddDialog,
                      icon: const Icon(Icons.add_business),
                      label: Text(l10n.addNewBranch),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
                    ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<BranchesCubit>().silentRefreshAllBranches(),
            color: AppColors.info,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;
                  if (constraints.maxWidth >= 1400) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth >= 1000) {
                    crossAxisCount = 3;
                  } else if (constraints.maxWidth >= 600) {
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
                      childAspectRatio: crossAxisCount == 1 ? 1.8 : 1.18,
                    ),
                    itemCount: branches.length,
                    itemBuilder: (_, i) {
                      final branch = branches[i];
                      return BranchCard(
                        branch: branch,
                        onTap: () => _openEditDialog(branch),
                        onEdit: () => _openEditDialog(branch),
                        onArchive: () => _confirmArchive(branch),
                        onUnArchive: () => context.read<BranchesCubit>().unArchiveBranch(branch.id),
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
