import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/features/pos/presentation/widgets/receipt_preview_card.dart';
import 'package:ssa/features/settings/presentation/widgets/settings_editor_widgets.dart';

class ReceiptHeaderEditorPage extends StatefulWidget {
  const ReceiptHeaderEditorPage({
    super.key,
    required this.initialSettings,
  });

  final ReceiptSettings initialSettings;

  @override
  State<ReceiptHeaderEditorPage> createState() => _ReceiptHeaderEditorPageState();
}

class _ReceiptHeaderEditorPageState extends State<ReceiptHeaderEditorPage> {
  static const double _receiptPreviewWidth = 288;
  static const ReceiptSettings _defaultSettings = ReceiptSettings(
    title: AppStrings.receiptShopTitle,
    phones: AppStrings.receiptPhones,
    titleFontSize: 22,
    phonesFontSize: 16,
    rowFontSize: 14,
    paddingTop: 10,
    paddingHorizontal: 12,
    paddingBottom: 40,
    printDensityPreset: PrintDensityPreset.balanced,
    feedLinesAfterPrint: 0,
  );

  late final TextEditingController _titleController;
  late final TextEditingController _phonesController;
  late double _titleFontSize;
  late double _phonesFontSize;
  late double _rowFontSize;
  late double _paddingTop;
  late double _paddingHorizontal;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialSettings.title);
    _phonesController = TextEditingController(
      text: widget.initialSettings.phones,
    );
    _titleFontSize = widget.initialSettings.titleFontSize;
    _phonesFontSize = widget.initialSettings.phonesFontSize;
    _rowFontSize = widget.initialSettings.rowFontSize;
    _paddingTop = widget.initialSettings.paddingTop;
    _paddingHorizontal = widget.initialSettings.paddingHorizontal;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _phonesController.dispose();
    super.dispose();
  }

  void _restoreDefaults() {
    setState(() {
      _titleController.text = _defaultSettings.title;
      _phonesController.text = _defaultSettings.phones;
      _titleFontSize = _defaultSettings.titleFontSize;
      _phonesFontSize = _defaultSettings.phonesFontSize;
      _rowFontSize = _defaultSettings.rowFontSize;
      _paddingTop = _defaultSettings.paddingTop;
      _paddingHorizontal = _defaultSettings.paddingHorizontal;
    });
  }

  void _save() {
    Navigator.of(context).pop(
      ReceiptSettings(
        title: _titleController.text.trim().isEmpty
            ? widget.initialSettings.title
            : _titleController.text.trim(),
        phones: _phonesController.text.trim().isEmpty
            ? widget.initialSettings.phones
            : _phonesController.text.trim(),
        titleFontSize: _titleFontSize,
        phonesFontSize: _phonesFontSize,
        rowFontSize: _rowFontSize,
        paddingTop: _paddingTop,
        paddingHorizontal: _paddingHorizontal,
        paddingBottom: ReceiptSettingsService.fixedPaddingBottom,
        printDensityPreset: widget.initialSettings.printDensityPreset,
        feedLinesAfterPrint: widget.initialSettings.feedLinesAfterPrint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.receiptPreviewLabel),
        actions: [
          TextButton(
            onPressed: _restoreDefaults,
            child: Text(AppStrings.restoreDefaults),
          ),
          const SizedBox(width: AppDimens.spacing8),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.pagePadding,
                AppDimens.pagePadding,
                AppDimens.spacing12,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final receiptWidth = constraints.maxWidth >=
                          (_receiptPreviewWidth + (AppDimens.spacing12 * 2))
                      ? _receiptPreviewWidth
                      : (constraints.maxWidth - (AppDimens.spacing12 * 2))
                            .clamp(220.0, _receiptPreviewWidth);

                  return Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: receiptWidth + (AppDimens.spacing12 * 2),
                      padding: const EdgeInsets.all(AppDimens.spacing12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppDimens.radius16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: receiptWidth,
                          child: ReceiptPreviewCard(
                            width: receiptWidth,
                            title: _titleController.text.trim().isEmpty
                                ? widget.initialSettings.title
                                : _titleController.text.trim(),
                            phones: _phonesController.text.trim().isEmpty
                                ? widget.initialSettings.phones
                                : _phonesController.text.trim(),
                            titleFontSize: _titleFontSize,
                            phonesFontSize: _phonesFontSize,
                            rowFontSize: _rowFontSize,
                            paddingTop: _paddingTop,
                            paddingHorizontal: _paddingHorizontal,
                            paddingBottom:
                                ReceiptSettingsService.fixedPaddingBottom,
                            borderRadius: AppDimens.radius8,
                            rows: const [
                              ReceiptPreviewRowData(
                                label: 'Date/Time',
                                value: '09-03-2026 10:10 AM',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Recipient',
                                value: 'Mg Mg',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Phone',
                                value: '09123456789',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Address',
                                value: 'Yangon',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Facebook Account',
                                value: 'user.name',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Parcel Number',
                                value: 'P-001',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Payment Status',
                                value: 'Payment Due',
                              ),
                              ReceiptPreviewRowData(
                                label: 'Note',
                                value: '-',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                0,
                AppDimens.pagePadding,
                AppDimens.spacing24,
              ),
              children: [
                SettingsEditorSection(
                  title: 'Header',
                  subtitle: 'Shop title and phone line',
                  child: Column(
                    children: [
                      MinimalSettingsTextField(
                        controller: _titleController,
                        label: AppStrings.receiptTitleLabel,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                      MinimalSettingsSlider(
                        label: AppStrings.receiptTitleLabel,
                        value: _titleFontSize,
                        min: 14,
                        max: 36,
                        onChanged: (value) =>
                            setState(() => _titleFontSize = value),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                      MinimalSettingsTextField(
                        controller: _phonesController,
                        label: AppStrings.receiptPhonesLabel,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                      MinimalSettingsSlider(
                        label: AppStrings.receiptPhonesLabel,
                        value: _phonesFontSize,
                        min: 10,
                        max: 28,
                        onChanged: (value) =>
                            setState(() => _phonesFontSize = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.spacing12),
                SettingsEditorSection(
                  title: 'Layout',
                  subtitle: 'Typography and spacing',
                  child: Column(
                    children: [
                      MinimalSettingsSlider(
                        label: AppStrings.receiptRowFontSizeLabel,
                        value: _rowFontSize,
                        min: 10,
                        max: 24,
                        onChanged: (value) => setState(() => _rowFontSize = value),
                      ),
                      const SizedBox(height: AppDimens.spacing8),
                      MinimalSettingsSlider(
                        label: AppStrings.receiptPaddingTopLabel,
                        value: _paddingTop,
                        min: 0,
                        max: 48,
                        onChanged: (value) => setState(() => _paddingTop = value),
                      ),
                      const SizedBox(height: AppDimens.spacing8),
                      MinimalSettingsSlider(
                        label: AppStrings.receiptPaddingHorizontalLabel,
                        value: _paddingHorizontal,
                        min: 0,
                        max: 32,
                        onChanged: (value) =>
                            setState(() => _paddingHorizontal = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.spacing16),
                Padding(
                  padding: const EdgeInsets.only(bottom: AppDimens.spacing12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      child: Text(AppStrings.save),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
