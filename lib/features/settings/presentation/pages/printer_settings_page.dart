import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/core/backup/local_backup_service.dart';
import 'package:ssa/core/settings/locale_settings_service.dart';
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/shared/providers/app_providers.dart';
import 'package:ssa/shared/widgets/app_drawer.dart';

class PrinterSettingsPage extends ConsumerStatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  ConsumerState<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends ConsumerState<PrinterSettingsPage> {
  bool _loading = true;
  ReceiptSettings _settings = const ReceiptSettings(
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  Future<void> _loadSettings() async {
    final service = ref.read(receiptSettingsServiceProvider);
    final settings = await service.load(
      defaultTitle: AppStrings.receiptShopTitle,
      defaultPhones: AppStrings.receiptPhones,
      defaultTitleFontSize: 22,
      defaultPhonesFontSize: 16,
      defaultRowFontSize: 14,
      defaultPaddingTop: 10,
      defaultPaddingHorizontal: 12,
      defaultPaddingBottom: 40,
      defaultPrintDensityPreset: PrintDensityPreset.balanced,
      defaultFeedLinesAfterPrint: 0,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _saveSettings(ReceiptSettings next) async {
    final service = ref.read(receiptSettingsServiceProvider);
    final saved = await service.save(
      title: next.title,
      phones: next.phones,
      titleFontSize: next.titleFontSize,
      phonesFontSize: next.phonesFontSize,
      rowFontSize: next.rowFontSize,
      paddingTop: next.paddingTop,
      paddingHorizontal: next.paddingHorizontal,
      paddingBottom: next.paddingBottom,
      printDensityPreset: next.printDensityPreset,
      feedLinesAfterPrint: next.feedLinesAfterPrint,
    );
    if (!mounted) {
      return;
    }
    if (saved) {
      setState(() {
        _settings = next;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.settingsSaved)));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppStrings.settingsSaveFailed)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(activeRoute: AppRoutes.printerSettings),
      appBar: AppBar(title: Text(AppStrings.settings)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radius12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  title: Text(AppStrings.receiptHeaderSettings),
                  subtitle: Text(
                    '${AppStrings.receiptHeaderSettingsHint}\n${_settings.title}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await Navigator.of(context).push<ReceiptSettings>(
                      MaterialPageRoute(
                        builder: (_) => _ReceiptHeaderEditorPage(
                          initialSettings: _settings,
                        ),
                      ),
                    );
                    if (result == null) {
                      return;
                    }
                    await _saveSettings(result);
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radius12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  title: Text(AppStrings.printerTuningSettings),
                  subtitle: Text(
                    '${AppStrings.printerTuningSettingsHint}\n${_presetLabel(_settings.printDensityPreset)} - ${AppStrings.feedLinesLabel}: ${_settings.feedLinesAfterPrint}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final result = await Navigator.of(context).push<ReceiptSettings>(
                      MaterialPageRoute(
                        builder: (_) =>
                            _PrinterTuningEditorPage(initialSettings: _settings),
                      ),
                    );
                    if (result == null) {
                      return;
                    }
                    await _saveSettings(result);
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radius12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  title: Text(AppStrings.languageSettings),
                  subtitle: Text(
                    '${AppStrings.languageSettingsHint}\n${_languageLabelText(ref.watch(localeControllerProvider).languageCode)}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const _LanguageSettingsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radius12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  title: Text(AppStrings.backupRestoreSettings),
                  subtitle: Text(AppStrings.backupRestoreSettingsHint),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const _BackupRestorePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }

  String _presetLabel(PrintDensityPreset preset) {
    switch (preset) {
      case PrintDensityPreset.light:
        return AppStrings.printPresetLight;
      case PrintDensityPreset.balanced:
        return AppStrings.printPresetBalanced;
      case PrintDensityPreset.dark:
        return AppStrings.printPresetDark;
    }
  }
}

class _LanguageSettingsPage extends ConsumerWidget {
  const _LanguageSettingsPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    Future<void> onSelect(String languageCode) async {
      final saved = await ref
          .read(localeControllerProvider.notifier)
          .setLanguageCode(languageCode);
      if (!context.mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            saved ? AppStrings.languageUpdated : AppStrings.settingsSaveFailed,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.languageSettings)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radius12),
              side: const BorderSide(color: AppColors.border),
            ),
            title: Text(AppStrings.languageEnglish),
            trailing:
                locale.languageCode ==
                    LocaleSettingsService.defaultLanguageCode
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onSelect(LocaleSettingsService.defaultLanguageCode),
          ),
          const SizedBox(height: AppDimens.spacing12),
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radius12),
              side: const BorderSide(color: AppColors.border),
            ),
            title: Text(AppStrings.languageMyanmar),
            trailing:
                locale.languageCode ==
                    LocaleSettingsService.myanmarLanguageCode
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => onSelect(LocaleSettingsService.myanmarLanguageCode),
          ),
        ],
      ),
    );
  }
}

class _ReceiptHeaderEditorPage extends StatefulWidget {
  const _ReceiptHeaderEditorPage({required this.initialSettings});

  final ReceiptSettings initialSettings;

  @override
  State<_ReceiptHeaderEditorPage> createState() =>
      _ReceiptHeaderEditorPageState();
}

class _ReceiptHeaderEditorPageState extends State<_ReceiptHeaderEditorPage> {
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
    _phonesController = TextEditingController(text: widget.initialSettings.phones);
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
                          child: _buildReceiptPreviewCard(),
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
                _EditorSection(
                  title: 'Header',
                  subtitle: 'Shop title and phone line',
                  child: Column(
                    children: [
                      _MinimalTextField(
                        controller: _titleController,
                        label: AppStrings.receiptTitleLabel,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                      _MinimalSlider(
                        label: AppStrings.receiptTitleLabel,
                        value: _titleFontSize,
                        min: 14,
                        max: 36,
                        onChanged: (value) => setState(() => _titleFontSize = value),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                      _MinimalTextField(
                        controller: _phonesController,
                        label: AppStrings.receiptPhonesLabel,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppDimens.spacing12),
                      _MinimalSlider(
                        label: AppStrings.receiptPhonesLabel,
                        value: _phonesFontSize,
                        min: 10,
                        max: 28,
                        onChanged: (value) => setState(() => _phonesFontSize = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimens.spacing12),
                _EditorSection(
                  title: 'Layout',
                  subtitle: 'Typography and spacing',
                  child: Column(
                    children: [
                      _MinimalSlider(
                        label: AppStrings.receiptRowFontSizeLabel,
                        value: _rowFontSize,
                        min: 10,
                        max: 24,
                        onChanged: (value) => setState(() => _rowFontSize = value),
                      ),
                      const SizedBox(height: AppDimens.spacing8),
                      _MinimalSlider(
                        label: AppStrings.receiptPaddingTopLabel,
                        value: _paddingTop,
                        min: 0,
                        max: 48,
                        onChanged: (value) => setState(() => _paddingTop = value),
                      ),
                      const SizedBox(height: AppDimens.spacing8),
                      _MinimalSlider(
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

  Widget _buildReceiptPreviewCard() {
    return Container(
      width: _receiptPreviewWidth,
      padding: EdgeInsets.only(
        top: _paddingTop,
        left: _paddingHorizontal,
        right: _paddingHorizontal,
        bottom: ReceiptSettingsService.fixedPaddingBottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimens.radius8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              _titleController.text.trim().isEmpty
                  ? widget.initialSettings.title
                  : _titleController.text.trim(),
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: _titleFontSize,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Center(
            child: Text(
              _phonesController.text.trim().isEmpty
                  ? widget.initialSettings.phones
                  : _phonesController.text.trim(),
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: _phonesFontSize,
              ),
            ),
          ),
          const SizedBox(height: AppDimens.spacing8),
          const Divider(height: 1, color: AppColors.divider),
          _PreviewReceiptRow(
            label: AppStrings.receiptDateTimeLabel,
            value: '09-03-2026 10:10 AM',
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.nameLabel,
            value: 'Mg Mg',
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.phoneLabel,
            value: '09123456789',
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.addressLabel,
            value: 'Yangon',
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.facebookLabel,
            value: 'user.name',
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.parcelNumberLabel,
            value: 'P-001',
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.paymentStatusLabel,
            value: AppStrings.paymentStatusDue,
            fontSize: _rowFontSize,
          ),
          _PreviewReceiptRow(
            label: AppStrings.noteLabel,
            value: '-',
            fontSize: _rowFontSize,
          ),
        ],
      ),
    );
  }
}


class _BackupRestorePage extends ConsumerStatefulWidget {
  const _BackupRestorePage();

  @override
  ConsumerState<_BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends ConsumerState<_BackupRestorePage> {
  bool _working = false;
  String _workingMessage = AppStrings.backupPreparingExport;

  ButtonStyle get _actionButtonStyle => OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(AppDimens.buttonHeight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.buttonRadius),
        ),
      );

  Future<void> _exportBackup() async {
    if (_working) {
      return;
    }
    setState(() {
      _working = true;
      _workingMessage = AppStrings.backupPreparingExport;
    });
    try {
      final backupService = ref.read(localBackupServiceProvider);
      final bytes = await backupService.exportBackupZipBytes();
      if (!mounted) {
        return;
      }
      setState(() {
        _workingMessage = AppStrings.backupWritingExport;
      });
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: AppStrings.exportBackup,
        fileName: backupService.backupFileName(DateTime.now()),
        bytes: bytes,
      );
      if (savePath == null || !mounted) {
        return;
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.backupExportSuccess)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.backupExportFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
        });
      }
    }
  }

  Future<void> _exportDataOnlyBackup() async {
    if (_working) {
      return;
    }
    setState(() {
      _working = true;
      _workingMessage = AppStrings.backupPreparingDataOnlyExport;
    });
    try {
      final backupService = ref.read(localBackupServiceProvider);
      final bytes = await backupService.exportDataOnlyBackupBytes();
      if (!mounted) {
        return;
      }
      setState(() {
        _workingMessage = AppStrings.backupWritingExport;
      });
      final savePath = await FilePicker.platform.saveFile(
        dialogTitle: AppStrings.exportDataOnlyBackup,
        fileName: backupService.dataOnlyBackupFileName(DateTime.now()),
        bytes: bytes,
      );
      if (savePath == null || !mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.backupDataOnlyExportSuccess)),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.backupDataOnlyExportFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _working = false;
        });
      }
    }
  }

  Future<void> _importBackup() async {
    if (_working) {
      return;
    }

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const <String>['zip', 'sqlite', 'db'],
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.backupImportFailed)),
      );
      return;
    }

    final importPath = result?.files.single.path;
    if (importPath == null || !mounted) {
      return;
    }
    final backupService = ref.read(localBackupServiceProvider);
    final importType = backupService.detectImportType(importPath);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(AppStrings.backupRestoreConfirmTitle),
          content: Text(
            importType == BackupImportType.full
                ? AppStrings.backupRestoreConfirmMessage
                : AppStrings.backupRestoreDataOnlyConfirmMessage,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(AppStrings.importBackup),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _working = true;
      _workingMessage = AppStrings.backupPreparingImport;
    });
    try {
      setState(() {
        _workingMessage = importType == BackupImportType.full
            ? AppStrings.backupRestoring
            : AppStrings.backupRestoringDataOnly;
      });
      final database = ref.read(appDatabaseProvider);
      if (importType == BackupImportType.full) {
        await backupService.restoreFromZip(
          importPath,
          closeDatabase: database.close,
        );
      } else {
        await backupService.restoreFromSqlite(
          importPath,
          closeDatabase: database.close,
        );
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            importType == BackupImportType.full
                ? AppStrings.backupRestoreSuccess
                : AppStrings.backupRestoreDataOnlySuccess,
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 600));
      await SystemNavigator.pop();
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.backupRestoreFailed)),
      );
      setState(() {
        _working = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_working,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.backupRestoreSettings),
          automaticallyImplyLeading: !_working,
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.pagePadding,
                AppDimens.pagePadding,
                AppDimens.spacing24,
              ),
              children: [
                _EditorSection(
                  title: AppStrings.backupRestoreSettings,
                  subtitle: AppStrings.backupRestoreSettingsHint,
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                      child: OutlinedButton.icon(
                        style: _actionButtonStyle,
                        onPressed: _working ? null : _exportBackup,
                        icon: const Icon(Icons.save_alt_outlined),
                        label: Text(AppStrings.exportBackup),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacing12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: _actionButtonStyle,
                        onPressed: _working ? null : _exportDataOnlyBackup,
                        icon: const Icon(Icons.dataset_linked_outlined),
                        label: Text(AppStrings.exportDataOnlyBackup),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacing12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                          style: _actionButtonStyle,
                          onPressed: _working ? null : _importBackup,
                          icon: const Icon(Icons.file_open_outlined),
                          label: Text(AppStrings.importBackup),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_working) ...[
              const ModalBarrier(
                dismissible: false,
                color: Color(0x66000000),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.spacing16),
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spacing24,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppDimens.radius16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: AppDimens.spacing12),
                      Text(
                        _workingMessage,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}

String _languageLabelText(String languageCode) {
  return languageCode == LocaleSettingsService.myanmarLanguageCode
      ? AppStrings.languageMyanmar
      : AppStrings.languageEnglish;
}

class _PrinterTuningEditorPage extends StatefulWidget {
  const _PrinterTuningEditorPage({required this.initialSettings});

  final ReceiptSettings initialSettings;

  @override
  State<_PrinterTuningEditorPage> createState() => _PrinterTuningEditorPageState();
}

class _PrinterTuningEditorPageState extends State<_PrinterTuningEditorPage> {
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
          _EditorSection(
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
                    _PresetChip(
                      label: AppStrings.printPresetLight,
                      selected: _printDensityPreset == PrintDensityPreset.light,
                      onTap: () => setState(() {
                        _printDensityPreset = PrintDensityPreset.light;
                      }),
                    ),
                    _PresetChip(
                      label: AppStrings.printPresetBalanced,
                      selected:
                          _printDensityPreset == PrintDensityPreset.balanced,
                      onTap: () => setState(() {
                        _printDensityPreset = PrintDensityPreset.balanced;
                      }),
                    ),
                    _PresetChip(
                      label: AppStrings.printPresetDark,
                      selected: _printDensityPreset == PrintDensityPreset.dark,
                      onTap: () => setState(() {
                        _printDensityPreset = PrintDensityPreset.dark;
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.spacing16),
                _MinimalSlider(
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

class _EditorSection extends StatelessWidget {
  const _EditorSection({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppDimens.spacing4),
          Text(subtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppDimens.spacing16),
          child,
        ],
      ),
    );
  }
}

class _MinimalTextField extends StatelessWidget {
  const _MinimalTextField({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacing12,
        vertical: AppDimens.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodySmall,
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

class _MinimalSlider extends StatelessWidget {
  const _MinimalSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spacing12,
        AppDimens.spacing12,
        AppDimens.spacing12,
        AppDimens.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.labelLarge)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing8,
                  vertical: AppDimens.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radius12),
                ),
                child: Text(
                  value.toStringAsFixed(0),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.divider,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withAlpha(24),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              value: value.clamp(min, max),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacing12,
          vertical: AppDimens.spacing8,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: selected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PreviewReceiptRow extends StatelessWidget {
  const _PreviewReceiptRow({
    required this.label,
    required this.value,
    required this.fontSize,
  });

  final String label;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacing8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}

