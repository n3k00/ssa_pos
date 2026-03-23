import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/printer/printer_connection_health.dart';
import 'package:ssa/features/pos/data/datasources/voucher_image_local_datasource.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_print_preview_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';
import 'package:uuid/uuid.dart';

class VoucherFormPage extends StatelessWidget {
  const VoucherFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.voucherFormTitle)),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimens.pagePadding),
          child: VoucherFormSection(popOnSave: true),
        ),
      ),
    );
  }
}

class VoucherFormSection extends ConsumerStatefulWidget {
  const VoucherFormSection({
    super.key,
    this.popOnSave = false,
    this.showPreviewButton = true,
  });

  final bool popOnSave;
  final bool showPreviewButton;

  @override
  ConsumerState<VoucherFormSection> createState() => VoucherFormSectionState();
}

class VoucherFormSectionState extends ConsumerState<VoucherFormSection> {
  static const Uuid _uuid = Uuid();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _parcelController = TextEditingController();
  final TextEditingController _paymentStatusController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _itemImagePath;

  void _clearKeyboardFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _facebookController.dispose();
    _parcelController.dispose();
    _paymentStatusController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.requiredFieldMessage;
    }
    return null;
  }

  void _resetFormForNextEntry() {
    _clearKeyboardFocus();
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _addressController.clear();
      _facebookController.clear();
      _parcelController.clear();
      _paymentStatusController.clear();
      _noteController.clear();
      _itemImagePath = null;
    });
  }

  Future<void> _pickItemImage(VoucherImageSource source) async {
    final dataSource = ref.read(voucherImageLocalDataSourceProvider);
    final pickedPath = await dataSource.pickAndSave(
      source: source,
      type: VoucherImageType.item,
    );
    if (pickedPath == null || !mounted) {
      return;
    }
    if (_itemImagePath != null && _itemImagePath != pickedPath) {
      await dataSource.deleteSavedImage(_itemImagePath);
    }
    setState(() {
      _itemImagePath = pickedPath;
    });
  }

  Future<void> _showPickSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.camera),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _pickItemImage(VoucherImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(AppStrings.gallery),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _pickItemImage(VoucherImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeItemImage() async {
    final currentPath = _itemImagePath;
    if (currentPath == null) {
      return;
    }
    await ref
        .read(voucherImageLocalDataSourceProvider)
        .deleteSavedImage(currentPath);
    if (!mounted) {
      return;
    }
    setState(() {
      _itemImagePath = null;
    });
  }

  Future<void> submitPreview() async {
    _clearKeyboardFocus();
    final form = _formKey.currentState;
    final isValid = form?.validate() ?? false;
    if (!isValid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.fillRequiredFields)),
        );
      }
      return;
    }

    final printerCore = ref.read(printerCoreProvider);
    final isConnected = await PrinterConnectionHealth.refresh(printerCore);
    if (!isConnected) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.printerRequiredForPreview)),
        );
      }
      return;
    }

    final now = DateTime.now();
    final voucher = Voucher(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      dateAndTime: now.toIso8601String(),
      paymentStatus: _paymentStatusController.text.trim(),
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      facebookAccount: _facebookController.text.trim().isEmpty
          ? null
          : _facebookController.text.trim(),
      parcelNumber: _parcelController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      itemImagePath: _itemImagePath,
      dispatchReceiptImagePath: null,
      dispatchReceiptSavedAt: null,
      syncStatus: 'pending',
      syncedAt: null,
      createdDeviceId: null,
    );

    if (!mounted) {
      return;
    }
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => VoucherPrintPreviewPage(
          voucher: voucher,
          popOnSave: widget.popOnSave,
        ),
      ),
    );
    if (!mounted) {
      return;
    }
    if (saved == true && !widget.popOnSave) {
      _resetFormForNextEntry();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: AppStrings.nameLabel),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimens.spacing12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: AppStrings.phoneLabel),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimens.spacing12),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: AppStrings.addressLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimens.spacing12),
          TextFormField(
            controller: _facebookController,
            decoration: InputDecoration(
              labelText: AppStrings.facebookLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimens.spacing12),
          TextFormField(
            controller: _parcelController,
            decoration: InputDecoration(
              labelText: AppStrings.parcelNumberLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimens.spacing12),
          TextFormField(
            controller: _paymentStatusController,
            decoration: InputDecoration(
              labelText: AppStrings.paymentStatusLabel,
            ),
            validator: _requiredValidator,
          ),
          const SizedBox(height: AppDimens.spacing12),
          TextFormField(
            controller: _noteController,
            decoration: InputDecoration(labelText: AppStrings.noteLabel),
            maxLines: 3,
          ),
          const SizedBox(height: AppDimens.spacing12),
          Text(AppStrings.itemImageLabel, style: AppTextStyles.labelLarge),
          const SizedBox(height: AppDimens.spacing8),
          InkWell(
            onTap: _showPickSourceSheet,
            borderRadius: BorderRadius.circular(AppDimens.radius12),
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius12),
                border: Border.all(color: AppColors.border),
              ),
              child: _itemImagePath == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_a_photo_outlined,
                            size: AppDimens.icon28,
                          ),
                          const SizedBox(height: AppDimens.spacing8),
                          Text(
                            AppStrings.pickImage,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppDimens.radius12,
                          ),
                          child: Image.file(
                            File(_itemImagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: AppDimens.spacing8,
                          right: AppDimens.spacing8,
                          child: Row(
                            children: [
                              _ImageActionIcon(
                                icon: Icons.edit_outlined,
                                onTap: _showPickSourceSheet,
                              ),
                              const SizedBox(width: AppDimens.spacing8),
                              _ImageActionIcon(
                                icon: Icons.delete_outline,
                                onTap: _removeItemImage,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          if (widget.showPreviewButton) ...[
            const SizedBox(height: AppDimens.spacing8),
            ElevatedButton(
              onPressed: submitPreview,
              child: Text(AppStrings.printPreview),
            ),
          ],
        ],
      ),
    );
  }
}

class _ImageActionIcon extends StatelessWidget {
  const _ImageActionIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.black.withAlpha(115),
      borderRadius: BorderRadius.circular(AppDimens.radius8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius8),
        child: Padding(
          padding: EdgeInsets.all(AppDimens.spacing8),
          child: Icon(icon, color: AppColors.white, size: AppDimens.icon20),
        ),
      ),
    );
  }
}
