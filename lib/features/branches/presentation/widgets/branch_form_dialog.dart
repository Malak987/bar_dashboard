import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/branch_entity.dart';
import '../cubit/branches_cubit.dart';

class BranchFormDialog extends StatefulWidget {
  final BranchEntity? branch;

  const BranchFormDialog({super.key, this.branch});

  @override
  State<BranchFormDialog> createState() => _BranchFormDialogState();
}

class _BranchFormDialogState extends State<BranchFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _descriptionArController;
  late final TextEditingController _descriptionEnController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressArController;
  late final TextEditingController _addressEnController;

  bool get isEdit => widget.branch != null;

  @override
  void initState() {
    super.initState();
    final branch = widget.branch;
    _nameArController = TextEditingController(text: branch?.nameAr ?? '');
    _nameEnController = TextEditingController(text: branch?.nameEn ?? '');
    _descriptionArController = TextEditingController(text: branch?.descriptionAr ?? '');
    _descriptionEnController = TextEditingController(text: branch?.descriptionEn ?? '');
    _phoneController = TextEditingController(text: branch?.phone ?? '');
    _addressArController = TextEditingController(text: branch?.addressAr ?? '');
    _addressEnController = TextEditingController(text: branch?.addressEn ?? '');
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _phoneController.dispose();
    _addressArController.dispose();
    _addressEnController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<BranchesCubit>();
    final values = {
      'nameAr': _nameArController.text.trim(),
      'nameEn': _nameEnController.text.trim(),
      'descriptionAr': _descriptionArController.text.trim(),
      'descriptionEn': _descriptionEnController.text.trim(),
      'phone': _phoneController.text.trim(),
      'addressAr': _addressArController.text.trim(),
      'addressEn': _addressEnController.text.trim(),
    };

    if (isEdit) {
      cubit.updateBranch(
        id: widget.branch!.id,
        nameAr: values['nameAr']!,
        nameEn: values['nameEn']!,
        descriptionAr: values['descriptionAr']!,
        descriptionEn: values['descriptionEn']!,
        phone: values['phone']!,
        addressAr: values['addressAr']!,
        addressEn: values['addressEn']!,
      );
    } else {
      cubit.addBranch(
        nameAr: values['nameAr']!,
        nameEn: values['nameEn']!,
        descriptionAr: values['descriptionAr']!,
        descriptionEn: values['descriptionEn']!,
        phone: values['phone']!,
        addressAr: values['addressAr']!,
        addressEn: values['addressEn']!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<BranchesCubit, BranchesState>(
      listener: (context, state) {
        if (state is BranchActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is BranchActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: AppColors.surface,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620, maxHeight: 700),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Icon(isEdit ? Icons.edit : Icons.add_business, color: AppColors.info),
                      const SizedBox(width: 8),
                      Text(
                        isEdit ? l10n.branchFormEditTitle : l10n.branchFormAddTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textSecondary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _field(controller: _nameArController, label: l10n.branchNameAr, icon: Icons.store)),
                            const SizedBox(width: 12),
                            Expanded(child: _field(controller: _nameEnController, label: l10n.branchNameEn, icon: Icons.storefront)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _field(controller: _phoneController, label: l10n.phoneRequired, icon: Icons.phone, keyboardType: TextInputType.phone)),
                            const SizedBox(width: 12),
                            Expanded(child: _field(controller: _addressArController, label: l10n.addressAr, icon: Icons.location_on)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _field(controller: _addressEnController, label: l10n.addressEn, icon: Icons.location_on_outlined),
                        const SizedBox(height: 12),
                        _field(controller: _descriptionArController, label: l10n.descriptionAr, icon: Icons.description, maxLines: 3),
                        const SizedBox(height: 12),
                        _field(controller: _descriptionEnController, label: l10n.descriptionEn, icon: Icons.description_outlined, maxLines: 3),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: AppColors.info, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.branchCloseInfo,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: BlocBuilder<BranchesCubit, BranchesState>(
                    builder: (context, state) {
                      final isLoading = state is BranchActionLoading;
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                              child: Text(l10n.cancel),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: isLoading ? null : _submit,
                              icon: isLoading
                                  ? const SizedBox(width: 18,height: 18,child: CircularProgressIndicator(strokeWidth: 2,color: Colors.white))
                                  : Icon(isEdit ? Icons.save : Icons.add_business),
                              label: Text(isLoading ? l10n.saving : (isEdit ? l10n.saveChanges : l10n.addingBranch)),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final l10n = context.l10n;
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 18)),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.fieldRequired;
        }
        if (keyboardType == TextInputType.phone && value.trim().length < 8) {
          return l10n.invalidPhone;
        }
        return null;
      },
    );
  }
}
