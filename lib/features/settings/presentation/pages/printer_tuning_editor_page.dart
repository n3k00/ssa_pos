import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/features/settings/presentation/widgets/settings_editor_widgets.dart';

class PrinterTuningEditorPage extends StatefulWidget {
  const PrinterTuningEditorPage({
    super.key,
    required this.initialSettings,
  });

  final ReceiptSettings initialSettings;

  @override
  State<PrinterTuningEditorPage> createState() =>
      _PrinterTuningEditorPageState();
}

class _PrinterTuningEditorPageState extends State<PrinterTuningEditorPage> {
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

  late PrintDensityPreset _printDensityPreset;
  late double _feedLinesAfterPrint;

  @override
  void initState() {
    super.initState();
    _printDensityPreset = widget.initialSettings.printDensityPreset;
    _feedLinesAfterPrint = widget.initialSettings.feedLinesAfterPrint.toDouble();
  }

  void _restoreDefaults() {
    setState(() {
      _printDensityPreset = _defaultSettings.printDensityPreset;
      _feedLinesAfterPrint = _defaultSettings.feedLinesAfterPrint.toDouble();
    });
  }

  void _save() {
    Navigator.of(context).pop(
      ReceiptSettings(
        title: widget.initialSettings.title,
        phones: widget.initialSettings.phones,
        titleFontSize: widget.initialSettings.titleFontSize,
        phonesFontSize: widget.initialSettings.phonesFontSize,
        rowFontSize: widget.initialSettings.rowFontSize,
        paddingTop: widget.initialSettings.paddingTop,
        paddingHorizontal: widget.initialSettings.paddingHorizontal,
        paddingBottom: widget.initialSettings.paddingBottom,
        printDensityPreset: _printDensityPreset,
        feedLinesAfterPrint: _feedLinesAfterPrint.round(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.printerTuningSettings),
        actions: [
          TextButton(
            onPressed: _restoreDefaults,
            child: Text(AppStrings.restoreDefaults),
          ),
          const SizedBox(width: AppDimens.spacing8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pagePadding,
          AppDimens.pagePadding,
          AppDimens.pagePadding,
          AppDimens.spacing24,
        ),
        children: [
          SettingsEditorSection(
            title: AppStrings.printerTuningSettings,
            subtitle: AppStrings.printerTuningSettingsHint,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.printPresetLabel,
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: AppDimens.spacing12),
                Wrap(
                  spacing: AppDimens.spacing8,
                  runSpacing: AppDimens.spacing8,
                  children: [
                    SettingsPresetChip(
                      label: AppStrings.printPresetLight,
                      selected: _printDensityPreset == PrintDensityPreset.light,
                      onTap: () => setState(() {
                        _printDensityPreset = PrintDensityPreset.light;
                      }),
                    ),
                    SettingsPresetChip(
                      label: AppStrings.printPresetBalanced,
                      selected:
                          _printDensityPreset == PrintDensityPreset.balanced,
                      onTap: () => setState(() {
                        _printDensityPreset = PrintDensityPreset.balanced;
                      }),
                    ),
                    SettingsPresetChip(
                      label: AppStrings.printPresetDark,
                      selected: _printDensityPreset == PrintDensityPreset.dark,
                      onTap: () => setState(() {
                        _printDensityPreset = PrintDensityPreset.dark;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spacing16),
                MinimalSettingsSlider(
                  label: AppStrings.feedLinesLabel,
                  value: _feedLinesAfterPrint,
                  min: 0,
                  max: 6,
                  onChanged: (value) => setState(() {
                    _feedLinesAfterPrint = value;
                  }),
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
    );
  }
}
