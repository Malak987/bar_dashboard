import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/context_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/multipart_helper.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../flavors/domain/entities/flavor_entity.dart';
import '../../../flavors/presentation/cubit/flavors_cubit.dart';
import '../../../product_sizes/presentation/cubit/product_sizes_cubit.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/products_repository.dart';
import '../cubit/products_cubit.dart';

/// 🎯 Wizard لإضافة منتج كامل على 3 خطوات
/// 1. البيانات الأساسية → AddProduct
/// 2. الأحجام → AddProductSize (متعددة)
/// 3. النكهات → AssignFlavorsToProduct
class ProductWizardDialog extends StatefulWidget {
  /// لو مش null → معناه edit mode
  final ProductEntity? existingProduct;

  const ProductWizardDialog({super.key, this.existingProduct});

  @override
  State<ProductWizardDialog> createState() => _ProductWizardDialogState();
}

class _ProductWizardDialogState extends State<ProductWizardDialog> {
  int _currentStep = 0;

  // الـ productId اللي بنرجعه بعد الـ AddProduct (للخطوات الجاية)
  String? _createdProductId;

  // الأحجام والنكهات اللي بنخزنها قبل الإضافة
  final List<_SizeData> _sizes = [];
  final List<_FlavorSelection> _selectedFlavors = [];

  bool get isEdit => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      _createdProductId = widget.existingProduct!.id;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  void _next() => setState(() => _currentStep++);
  void _prev() => setState(() => _currentStep--);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 750),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            _buildStepperIndicator(),
            const Divider(height: 1, color: AppColors.border),
            Expanded(child: _buildCurrentStep()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.add_box, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            isEdit ? context.l10n.productWizardEditTitle : context.l10n.productWizardAddTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close,
                color: AppColors.textSecondary),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepperIndicator() {
    final steps = [
      context.l10n.wizardStepBasic,
      context.l10n.wizardStepSizes,
      context.l10n.wizardStepFlavors,
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: AppColors.surfaceLight,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIdx = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: stepIdx < _currentStep
                    ? AppColors.primary
                    : AppColors.border,
              ),
            );
          }
          final stepIdx = i ~/ 2;
          final isActive = stepIdx == _currentStep;
          final isDone = stepIdx < _currentStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive || isDone
                      ? AppColors.primary
                      : AppColors.border,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isDone
                      ? const Icon(Icons.check,
                      color: Colors.white, size: 18)
                      : Text(
                    '${stepIdx + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                steps[stepIdx],
                style: TextStyle(
                  fontSize: 10,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _Step1BasicInfo(
          existingProduct: widget.existingProduct,
          onSuccess: (productId) {
            _createdProductId = productId;
            _next();
          },
        );
      case 1:
        return _Step2Sizes(
          productId: _createdProductId!,
          existingSizes:
          widget.existingProduct?.sizes.map((s) => s).toList() ?? [],
          sizes: _sizes,
          onAddSize: (size) {
            setState(() => _sizes.add(size));
          },
          onRemoveSize: (idx) {
            setState(() => _sizes.removeAt(idx));
          },
          onNext: _next,
          onBack: _prev,
        );
      case 2:
        return _Step3Flavors(
          productId: _createdProductId!,
          existingFlavors: widget.existingProduct?.flavors ?? [],
          selectedFlavors: _selectedFlavors,
          onToggleFlavor: (flavor) {
            setState(() {
              final idx = _selectedFlavors
                  .indexWhere((f) => f.flavor.id == flavor.id);
              if (idx >= 0) {
                _selectedFlavors.removeAt(idx);
              } else {
                _selectedFlavors
                    .add(_FlavorSelection(flavor: flavor, extraPrice: 0));
              }
            });
          },
          onUpdateExtraPrice: (flavorId, price) {
            setState(() {
              final idx = _selectedFlavors
                  .indexWhere((f) => f.flavor.id == flavorId);
              if (idx >= 0) {
                _selectedFlavors[idx] = _FlavorSelection(
                  flavor: _selectedFlavors[idx].flavor,
                  extraPrice: price,
                );
              }
            });
          },
          onBack: _prev,
          onFinish: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ============================================================
// Step 1: Basic Info
// ============================================================
class _Step1BasicInfo extends StatefulWidget {
  final ProductEntity? existingProduct;
  final void Function(String productId) onSuccess;

  const _Step1BasicInfo({
    this.existingProduct,
    required this.onSuccess,
  });

  @override
  State<_Step1BasicInfo> createState() => _Step1BasicInfoState();
}

class _Step1BasicInfoState extends State<_Step1BasicInfo> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _descArController;
  late final TextEditingController _descEnController;
  late final TextEditingController _sizeNameController;
  late final TextEditingController _basePriceController;

  late bool _isFeatured;
  late bool _isBestSeller;
  late bool _isCustomizable;
  String? _selectedCategoryId;

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;

  bool get isEdit => widget.existingProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.existingProduct;
    _nameArController = TextEditingController(text: p?.nameAr ?? '');
    _nameEnController = TextEditingController(text: p?.nameEn ?? '');
    _descArController = TextEditingController(text: p?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: p?.descriptionEn ?? '');
    _sizeNameController = TextEditingController(text: '');
    _basePriceController =
        TextEditingController(text: p?.basePrice.toString() ?? '0');
    _isFeatured = p?.isFeatured ?? false;
    _isBestSeller = p?.isBestSeller ?? false;
    _isCustomizable = p?.isCustomizable ?? false;
    _selectedCategoryId = p?.categoryId;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _sizeNameController.dispose();
    _basePriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _pickedImageBytes = bytes;
        _pickedImageName = image.name;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      _showError(context.l10n.selectCategoryError);
      return;
    }
    if (!isEdit && _pickedImageBytes == null) {
      _showError(context.l10n.selectProductImageError);
      return;
    }

    final multipartImage = _pickedImageBytes != null
        ? MultipartHelper.bytesToMultipart(
        _pickedImageBytes!, _pickedImageName ?? 'product.png')
        : null;

    if (isEdit) {
      context.read<ProductsCubit>().updateProduct(
        id: widget.existingProduct!.id,
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        sizeName: _sizeNameController.text.trim(),
        descriptionAr: _descArController.text.trim(),
        descriptionEn: _descEnController.text.trim(),
        basePrice:
        double.tryParse(_basePriceController.text) ?? 0,
        isFeatured: _isFeatured,
        isBestSeller: _isBestSeller,
        isCustomizable: _isCustomizable,
        categoryId: _selectedCategoryId!,
        image: multipartImage,
      );
    } else {
      context.read<ProductsCubit>().addProduct(
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        sizeName: _sizeNameController.text.trim(),
        descriptionAr: _descArController.text.trim(),
        descriptionEn: _descEnController.text.trim(),
        basePrice:
        double.tryParse(_basePriceController.text) ?? 0,
        isFeatured: _isFeatured,
        isBestSeller: _isBestSeller,
        isCustomizable: _isCustomizable,
        categoryId: _selectedCategoryId!,
        image: multipartImage,
      );
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          // الـ message هو الـ productId المرجع
          // (لو كان رقم نعتبره msg، لو شكله UUID نعتبره id)
          final productId = isEdit
              ? widget.existingProduct!.id
              : (state.message.contains('-')
              ? state.message
              : state.message);
          widget.onSuccess(productId);
        } else if (state is ProductActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImagePicker(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            _nameArController,
                            context.l10n.nameArField,
                            Icons.text_fields,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            _nameEnController,
                            context.l10n.nameEnField,
                            Icons.text_fields,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _textField(
                      _descArController,
                      context.l10n.descriptionArField,
                      Icons.description,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    _textField(
                      _descEnController,
                      context.l10n.descriptionEnField,
                      Icons.description,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _textField(
                            _sizeNameController,
                            context.l10n.defaultSizeNameField,
                            Icons.straighten,
                            required: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _textField(
                            _basePriceController,
                            context.l10n.basePriceField,
                            Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCategoryDropdown(),
                    const SizedBox(height: 16),
                    _switchTile(
                      context.l10n.featuredOptionTitle,
                      context.l10n.featuredOptionSubtitle,
                      _isFeatured,
                          (v) => setState(() => _isFeatured = v),
                      AppColors.warning,
                    ),
                    _switchTile(
                      context.l10n.bestSellerOptionTitle,
                      context.l10n.bestSellerOptionSubtitle,
                      _isBestSeller,
                          (v) => setState(() => _isBestSeller = v),
                      AppColors.accent,
                    ),
                    _switchTile(
                      context.l10n.customizableOptionTitle,
                      context.l10n.customizableOptionSubtitle,
                      _isCustomizable,
                          (v) => setState(() => _isCustomizable = v),
                      AppColors.info,
                    ),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final isLoading = state is ProductActionLoading;
          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(context.l10n.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _submit,
                  icon: isLoading
                      ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.arrow_forward),
                  label: Text(isLoading
                      ? context.l10n.saveAndContinueSizesLoading
                      : context.l10n.saveAndNextSizes),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImagePicker() {
    final l10n = context.l10n;
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: _pickedImageBytes != null
            ? Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_pickedImageBytes!,
                  fit: BoxFit.cover),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: CircleAvatar(
                backgroundColor: AppColors.error,
                radius: 16,
                child: IconButton(
                  icon: const Icon(Icons.close,
                      size: 16, color: Colors.white),
                  onPressed: () => setState(() {
                    _pickedImageBytes = null;
                    _pickedImageName = null;
                  }),
                ),
              ),
            ),
          ],
        )
            : (isEdit && widget.existingProduct?.fullImageUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            widget.existingProduct!.fullImageUrl!,
            fit: BoxFit.cover,
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate,
                size: 40, color: AppColors.textHint),
            const SizedBox(height: 8),
            Text(context.l10n.pickProductImage,
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12)),
          ],
        )),
      ),
    );
  }

  Widget _textField(
      TextEditingController controller,
      String label,
      IconData icon, {
        int maxLines = 1,
        TextInputType? keyboardType,
        bool required = true,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textHint, size: 18),
      ),
      validator: required
          ? (v) => (v?.isEmpty ?? true) ? context.l10n.requiredFieldShort : null
          : null,
    );
  }

  Widget _buildCategoryDropdown() {
    final l10n = context.l10n;
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const LinearProgressIndicator(
              color: AppColors.primary);
        }
        List<CategoryEntity> categories = [];
        if (state is CategoriesLoaded) {
          categories =
              state.categories.items.where((c) => !c.isArchived).toList();
        }
        if (categories.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.error),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: AppColors.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    context.l10n.noCategoriesFirst,
                    style: const TextStyle(color: AppColors.error, fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        }

        final valid = categories.any((c) => c.id == _selectedCategoryId);
        return DropdownButtonFormField<String>(
          initialValue: valid ? _selectedCategoryId : null,
          dropdownColor: AppColors.surfaceLight,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            labelText: context.l10n.categoryField,
            labelStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon:
            Icon(Icons.category, color: AppColors.textHint, size: 18),
          ),
          items: categories
              .map((c) => DropdownMenuItem(
            value: c.id,
            child: Text('${c.nameAr} / ${c.nameEn}'),
          ))
              .toList(),
          onChanged: (v) => setState(() => _selectedCategoryId = v),
          validator: (v) => v == null ? context.l10n.mustChooseCategory : null,
        );
      },
    );
  }

  Widget _switchTile(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        title: Text(title,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: AppColors.textHint, fontSize: 11)),
        value: value,
        activeColor: color,
        onChanged: onChanged,
        dense: true,
      ),
    );
  }
}

// ============================================================
// Step 2: Sizes (Multiple)
// ============================================================
class _SizeData {
  final String nameAr;
  final String nameEn;
  final String sizeName;
  final String descAr;
  final String descEn;
  final double price;
  final bool isAvailable;
  final double radius;
  final double height;
  final String serves;
  final Uint8List? imageBytes;
  final String? imageName;

  _SizeData({
    required this.nameAr,
    required this.nameEn,
    required this.sizeName,
    required this.descAr,
    required this.descEn,
    required this.price,
    required this.isAvailable,
    required this.radius,
    required this.height,
    required this.serves,
    this.imageBytes,
    this.imageName,
  });
}

class _Step2Sizes extends StatelessWidget {
  final String productId;
  final List<ProductSizeMiniEntity> existingSizes;
  final List<_SizeData> sizes;
  final void Function(_SizeData) onAddSize;
  final void Function(int) onRemoveSize;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _Step2Sizes({
    required this.productId,
    required this.existingSizes,
    required this.sizes,
    required this.onAddSize,
    required this.onRemoveSize,
    required this.onNext,
    required this.onBack,
  });

  void _openAddSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AddSizeDialog(
        onSave: (data) {
          onAddSize(data);
          Navigator.of(dialogContext).pop();
        },
      ),
    );
  }

  Future<void> _saveAllSizes(BuildContext context) async {
    if (sizes.isEmpty) {
      onNext();
      return;
    }
    final cubit = context.read<ProductSizesCubit>();
    for (final size in sizes) {
      await cubit.addProductSize(
        productId: productId,
        nameAr: size.nameAr,
        nameEn: size.nameEn,
        sizeName: size.sizeName,
        descriptionAr: size.descAr,
        descriptionEn: size.descEn,
        price: size.price,
        isAvailable: size.isAvailable,
        radius: size.radius,
        height: size.height,
        serves: size.serves,
        image: size.imageBytes != null
            ? MultipartHelper.bytesToMultipart(
            size.imageBytes!, size.imageName ?? 'size.png')
            : null,
      );
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.productSizeAddedSuccess(sizes.length)),
          backgroundColor: AppColors.success,
        ),
      );
      onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.productSizesTitle,
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(context.l10n.productSizesSubtitle,
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _openAddSizeDialog(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(context.l10n.addSize),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (existingSizes.isNotEmpty) ...[
                  Text(context.l10n.existingSizes,
                      style: TextStyle(
                          color: AppColors.textHint, fontSize: 11)),
                  const SizedBox(height: 4),
                  ...existingSizes.map((s) => _existingSizeRow(s)),
                  const SizedBox(height: 12),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 8),
                ],
                Expanded(
                  child: sizes.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.straighten,
                            size: 60, color: AppColors.textHint),
                        const SizedBox(height: 12),
                          Text(
                          context.l10n.noSizesAddedYet,
                          style: TextStyle(
                              color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                          Text(
                          context.l10n.skipIfNoSizes,
                          style: TextStyle(
                              color: AppColors.textHint,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: sizes.length,
                    itemBuilder: (context, i) =>
                        _sizeRow(context, sizes[i], () => onRemoveSize(i)),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildFooter(context),
      ],
    );
  }

  Widget _existingSizeRow(ProductSizeMiniEntity s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border:
        Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle,
              color: AppColors.success, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${s.nameAr} - L.E ${s.price.toStringAsFixed(0)}',
              style: const TextStyle(
                  color: AppColors.textPrimary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizeRow(
      BuildContext context,
      _SizeData s,
      VoidCallback onRemove,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          if (s.imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(s.imageBytes!,
                  width: 40, height: 40, fit: BoxFit.cover),
            )
          else
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.straighten,
                  color: AppColors.textHint),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.nameAr} (${s.nameEn})',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
                Text(
                  'L.E ${s.price} • قطر ${s.radius} • ارتفاع ${s.height}',
                  style: const TextStyle(
                      color: AppColors.textHint, fontSize: 11),
                ),
                if (s.serves.isNotEmpty)
                  Text('${context.l10n.servesField.split('(').first.trim()}: ${s.serves}',
                      style: const TextStyle(
                          color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete,
                color: AppColors.error, size: 18),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BlocBuilder<ProductSizesCubit, ProductSizesState>(
        builder: (context, state) {
          final isLoading = state is ProductSizeActionLoading;
          return Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(context.l10n.previous),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed:
                  isLoading ? null : () => _saveAllSizes(context),
                  icon: isLoading
                      ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.arrow_forward),
                  label: Text(isLoading
                      ? context.l10n.savingSizes
                      : (sizes.isEmpty
                      ? context.l10n.skipToFlavors
                      : context.l10n.saveSizesAndContinue(sizes.length))),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ============================================================
// Dialog for adding ONE size
// ============================================================
class _AddSizeDialog extends StatefulWidget {
  final void Function(_SizeData) onSave;
  const _AddSizeDialog({required this.onSave});

  @override
  State<_AddSizeDialog> createState() => _AddSizeDialogState();
}

class _AddSizeDialogState extends State<_AddSizeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameAr = TextEditingController();
  final _nameEn = TextEditingController();
  final _sizeName = TextEditingController();
  final _descAr = TextEditingController();
  final _descEn = TextEditingController();
  final _price = TextEditingController();
  final _radius = TextEditingController(text: '0');
  final _height = TextEditingController(text: '0');
  final _serves = TextEditingController();
  bool _isAvailable = true;
  Uint8List? _imageBytes;
  String? _imageName;

  @override
  void dispose() {
    _nameAr.dispose();
    _nameEn.dispose();
    _sizeName.dispose();
    _descAr.dispose();
    _descEn.dispose();
    _price.dispose();
    _radius.dispose();
    _height.dispose();
    _serves.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _imageName = img.name;
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSave(_SizeData(
      nameAr: _nameAr.text.trim(),
      nameEn: _nameEn.text.trim(),
      sizeName: _sizeName.text.trim(),
      descAr: _descAr.text.trim(),
      descEn: _descEn.text.trim(),
      price: double.tryParse(_price.text) ?? 0,
      isAvailable: _isAvailable,
      radius: double.tryParse(_radius.text) ?? 0,
      height: double.tryParse(_height.text) ?? 0,
      serves: _serves.text.trim(),
      imageBytes: _imageBytes,
      imageName: _imageName,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border:
                  Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.straighten,
                        color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(context.l10n.addSize,
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: _pickImage,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: _imageBytes != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(_imageBytes!,
                                fit: BoxFit.cover),
                          )
                              :   Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_photo_alternate,
                                    color: AppColors.textHint),
                                SizedBox(height: 4),
                                Text(context.l10n.sizeImageOptional,
                                    style: TextStyle(
                                        color: AppColors.textHint,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _f(_nameAr, context.l10n.sizeNameArField)),
                          const SizedBox(width: 8),
                          Expanded(child: _f(_nameEn, context.l10n.sizeNameEnField)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _f(_sizeName, context.l10n.sizeTokenField),
                      const SizedBox(height: 8),
                      _f(_descAr, context.l10n.sizeDescriptionArField, required: false),
                      const SizedBox(height: 8),
                      _f(_descEn, context.l10n.sizeDescriptionEnField, required: false),
                      const SizedBox(height: 8),
                      _f(_price, context.l10n.priceField,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                              child: _f(_radius, context.l10n.radiusField,
                                  keyboardType: TextInputType.number,
                                  required: false)),
                          const SizedBox(width: 8),
                          Expanded(
                              child: _f(_height, context.l10n.heightField,
                                  keyboardType: TextInputType.number,
                                  required: false)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _f(_serves, context.l10n.servesField,
                          required: false),
                      const SizedBox(height: 8),
                      SwitchListTile(
                        title: Text(context.l10n.availableSwitch,
                            style:
                            TextStyle(color: AppColors.textPrimary)),
                        value: _isAvailable,
                        activeColor: AppColors.success,
                        onChanged: (v) =>
                            setState(() => _isAvailable = v),
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  border:
                  Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(context.l10n.cancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.add, size: 18),
                        label: Text(context.l10n.addSizeAction),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _f(TextEditingController c, String label,
      {TextInputType? keyboardType, bool required = true}) {
    return TextFormField(
      controller: c,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            color: AppColors.textSecondary, fontSize: 12),
        isDense: true,
      ),
      validator: required
          ? (v) => (v?.isEmpty ?? true) ? context.l10n.requiredFieldShort : null
          : null,
    );
  }
}

// ============================================================
// Step 3: Flavors
// ============================================================
class _FlavorSelection {
  final FlavorEntity flavor;
  final double extraPrice;
  const _FlavorSelection({required this.flavor, required this.extraPrice});
}

class _Step3Flavors extends StatelessWidget {
  final String productId;
  final List<ProductFlavorMiniEntity> existingFlavors;
  final List<_FlavorSelection> selectedFlavors;
  final void Function(FlavorEntity) onToggleFlavor;
  final void Function(String flavorId, double price) onUpdateExtraPrice;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const _Step3Flavors({
    required this.productId,
    required this.existingFlavors,
    required this.selectedFlavors,
    required this.onToggleFlavor,
    required this.onUpdateExtraPrice,
    required this.onBack,
    required this.onFinish,
  });

  Future<void> _assign(BuildContext context) async {
    if (selectedFlavors.isEmpty) {
      onFinish();
      return;
    }
    await context.read<ProductsCubit>().assignFlavorsToProduct(
      productId: productId,
      flavors: selectedFlavors
          .map((s) => FlavorAssignment(
        flavorId: s.flavor.id,
        extraPrice: s.extraPrice,
      ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsCubit, ProductsState>(
      listener: (context, state) {
        if (state is ProductActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          onFinish();
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(context.l10n.availableFlavorsChooseTitle,
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(context.l10n.availableFlavorsChooseSubtitle,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<FlavorsCubit, FlavorsState>(
                      builder: (context, state) {
                        if (state is FlavorsLoading) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary));
                        }
                        if (state is FlavorsLoaded) {
                          final flavors = state.flavors.items
                              .where((f) => !f.isArchived)
                              .toList();
                          if (flavors.isEmpty) {
                            return Center(
                              child: Text(
                                  context.l10n.noFlavorsAvailable,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: AppColors.textSecondary)),
                            );
                          }
                          return ListView.builder(
                            itemCount: flavors.length,
                            itemBuilder: (_, i) {
                              final f = flavors[i];
                              final selectedIdx = selectedFlavors
                                  .indexWhere((s) => s.flavor.id == f.id);
                              final isSelected = selectedIdx >= 0;
                              return _flavorRow(
                                context,
                                f,
                                isSelected,
                                isSelected
                                    ? selectedFlavors[selectedIdx].extraPrice
                                    : 0,
                              );
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _flavorRow(
      BuildContext context,
      FlavorEntity flavor,
      bool isSelected,
      double extraPrice,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (_) => onToggleFlavor(flavor),
            activeColor: AppColors.primary,
          ),
          if (flavor.fullImageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                flavor.fullImageUrl!,
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _flavorPlaceholder(),
              ),
            )
          else
            _flavorPlaceholder(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(flavor.nameAr,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text(flavor.nameEn,
                    style: const TextStyle(
                        color: AppColors.textHint, fontSize: 11)),
              ],
            ),
          ),
          if (isSelected)
            SizedBox(
              width: 100,
              child: TextFormField(
                initialValue:
                extraPrice == 0 ? '' : extraPrice.toString(),
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  labelText: context.l10n.extraPriceField,
                  labelStyle: TextStyle(
                      color: AppColors.textHint, fontSize: 10),
                  isDense: true,
                ),
                onChanged: (v) => onUpdateExtraPrice(
                    flavor.id, double.tryParse(v) ?? 0),
              ),
            ),
        ],
      ),
    );
  }

  Widget _flavorPlaceholder() => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: AppColors.border,
      borderRadius: BorderRadius.circular(6),
    ),
    child: const Icon(Icons.local_drink,
        color: AppColors.textHint, size: 18),
  );

  Widget _buildFooter(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final isLoading = state is ProductActionLoading;
          return Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: isLoading ? null : onBack,
                  icon: const Icon(Icons.arrow_back),
                  label: Text(context.l10n.previous),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : () => _assign(context),
                  icon: isLoading
                      ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_circle),
                  label: Text(isLoading
                      ? context.l10n.saveAndContinueSizesLoading
                      : (selectedFlavors.isEmpty
                      ? context.l10n.finishWithoutFlavors
                      : context.l10n.saveFlavorsAndFinish(selectedFlavors.length))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
