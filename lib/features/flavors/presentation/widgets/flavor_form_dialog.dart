import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/multipart_helper.dart';
import '../../domain/entities/flavor_entity.dart';
import '../cubit/flavors_cubit.dart';

class FlavorFormDialog extends StatefulWidget {
  final FlavorEntity? flavor;

  const FlavorFormDialog({super.key, this.flavor});

  @override
  State<FlavorFormDialog> createState() => _FlavorFormDialogState();
}

class _FlavorFormDialogState extends State<FlavorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameArController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _descArController;
  late final TextEditingController _descEnController;

  late bool _isAvailable;

  Uint8List? _pickedImageBytes;
  String? _pickedImageName;

  bool get isEdit => widget.flavor != null;

  @override
  void initState() {
    super.initState();
    final f = widget.flavor;
    _nameArController = TextEditingController(text: f?.nameAr ?? '');
    _nameEnController = TextEditingController(text: f?.nameEn ?? '');
    _descArController = TextEditingController(text: f?.descriptionAr ?? '');
    _descEnController = TextEditingController(text: f?.descriptionEn ?? '');
    _isAvailable = f?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
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

    final cubit = context.read<FlavorsCubit>();
    final multipartImage = _pickedImageBytes != null
        ? MultipartHelper.bytesToMultipart(
        _pickedImageBytes!, _pickedImageName ?? 'flavor.png')
        : null;

    if (isEdit) {
      cubit.updateFlavor(
        id: widget.flavor!.id,
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        descriptionAr: _descArController.text.trim(),
        descriptionEn: _descEnController.text.trim(),
        isAvailable: _isAvailable,
        image: multipartImage,
      );
    } else {
      cubit.addFlavor(
        nameAr: _nameArController.text.trim(),
        nameEn: _nameEnController.text.trim(),
        descriptionAr: _descArController.text.trim(),
        descriptionEn: _descEnController.text.trim(),
        isAvailable: _isAvailable,
        image: multipartImage,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlavorsCubit, FlavorsState>(
      listener: (context, state) {
        if (state is FlavorActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is FlavorActionFailure) {
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
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 650),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      Icon(isEdit ? Icons.edit : Icons.add_circle,
                          color: AppColors.accent),
                      const SizedBox(width: 8),
                      Text(
                        isEdit ? 'تعديل نكهة' : 'إضافة نكهة جديدة',
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
                ),
                // Body
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
                              child: TextFormField(
                                controller: _nameArController,
                                style: const TextStyle(
                                    color: AppColors.textPrimary),
                                decoration: const InputDecoration(
                                  labelText: 'الاسم بالعربية *',
                                  prefixIcon:
                                  Icon(Icons.text_fields, size: 18),
                                ),
                                validator: (v) =>
                                (v?.isEmpty ?? true) ? 'مطلوب' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _nameEnController,
                                style: const TextStyle(
                                    color: AppColors.textPrimary),
                                decoration: const InputDecoration(
                                  labelText: 'Name (English) *',
                                  prefixIcon:
                                  Icon(Icons.text_fields, size: 18),
                                ),
                                validator: (v) =>
                                (v?.isEmpty ?? true)
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descArController,
                          maxLines: 2,
                          style: const TextStyle(
                              color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'الوصف بالعربية *',
                            prefixIcon:
                            Icon(Icons.description, size: 18),
                          ),
                          validator: (v) =>
                          (v?.isEmpty ?? true) ? 'مطلوب' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _descEnController,
                          maxLines: 2,
                          style: const TextStyle(
                              color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Description (English) *',
                            prefixIcon:
                            Icon(Icons.description, size: 18),
                          ),
                          validator: (v) =>
                          (v?.isEmpty ?? true) ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        // Available switch
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SwitchListTile(
                            title: const Text('متاحة للاختيار ✓',
                                style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                            subtitle: const Text(
                                'العملاء يقدروا يختاروا النكهة دي',
                                style: TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 11)),
                            value: _isAvailable,
                            activeColor: AppColors.success,
                            onChanged: (v) =>
                                setState(() => _isAvailable = v),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border:
                    Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: BlocBuilder<FlavorsCubit, FlavorsState>(
                    builder: (context, state) {
                      final isLoading = state is FlavorActionLoading;
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                              ),
                              child: const Text('إلغاء'),
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
                                      strokeWidth: 2,
                                      color: Colors.white))
                                  : Icon(isEdit
                                  ? Icons.save
                                  : Icons.add_circle),
                              label: Text(isLoading
                                  ? 'جاري...'
                                  : (isEdit
                                  ? 'حفظ التعديلات'
                                  : 'إضافة النكهة')),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                              ),
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

  Widget _buildImagePicker() {
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
            : (isEdit && widget.flavor?.fullImageUrl != null
            ? Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.flavor!.fullImageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.camera_alt,
                        color: Colors.white, size: 32),
                    SizedBox(height: 6),
                    Text('اضغط لتغيير الصورة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        )
            : _placeholder()),
      ),
    );
  }

  Widget _placeholder() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(Icons.add_photo_alternate,
          size: 40, color: AppColors.textHint),
      const SizedBox(height: 8),
      Text(
        isEdit ? 'اضغط لتغيير الصورة' : 'اضغط لاختيار صورة (اختياري)',
        style: const TextStyle(
            color: AppColors.textSecondary, fontSize: 12),
      ),
    ],
  );
}
