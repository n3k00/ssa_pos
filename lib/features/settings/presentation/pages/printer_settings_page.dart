import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/core/settings/locale_settings_service.dart';
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/features/settings/presentation/pages/backup_restore_page.dart';
import 'package:ssa/features/settings/presentation/pages/language_settings_page.dart';
import 'package:ssa/features/settings/presentation/pages/printer_tuning_editor_page.dart';
import 'package:ssa/features/settings/presentation/pages/profile_settings_page.dart';
import 'package:ssa/features/settings/presentation/pages/receipt_header_editor_page.dart';
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
    final localeCode = ref.watch(localeControllerProvider).languageCode;

    return Scaffold(
      drawer: const AppDrawer(activeRoute: AppRoutes.printerSettings),
      appBar: AppBar(title: Text(AppStrings.settings)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppDimens.pagePadding),
              children: [
                _SettingsNavTile(
                  title: AppStrings.profileSettings,
                  subtitle: AppStrings.profileSettingsHint,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ProfileSettingsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                _SettingsNavTile(
                  title: AppStrings.receiptHeaderSettings,
                  subtitle:
                      '${AppStrings.receiptHeaderSettingsHint}\n${_settings.title}',
                  onTap: () async {
                    final result = await Navigator.of(context).push<ReceiptSettings>(
                      MaterialPageRoute(
                        builder: (_) => ReceiptHeaderEditorPage(
                          initialSettings: _settings,
                        ),
                      ),
                    );
                    if (result != null) {
                      await _saveSettings(result);
                    }
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                _SettingsNavTile(
                  title: AppStrings.printerTuningSettings,
                  subtitle:
                      '${AppStrings.printerTuningSettingsHint}\n${_presetLabel(_settings.printDensityPreset)} - ${AppStrings.feedLinesLabel}: ${_settings.feedLinesAfterPrint}',
                  onTap: () async {
                    final result = await Navigator.of(context).push<ReceiptSettings>(
                      MaterialPageRoute(
                        builder: (_) => PrinterTuningEditorPage(
                          initialSettings: _settings,
                        ),
                      ),
                    );
                    if (result != null) {
                      await _saveSettings(result);
                    }
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                _SettingsNavTile(
                  title: AppStrings.languageSettings,
                  subtitle:
                      '${AppStrings.languageSettingsHint}\n${_languageLabelText(localeCode)}',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const LanguageSettingsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppDimens.spacing12),
                _SettingsNavTile(
                  title: AppStrings.backupRestoreSettings,
                  subtitle: AppStrings.backupRestoreSettingsHint,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const BackupRestorePage(),
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

class _SettingsNavTile extends StatelessWidget {
  const _SettingsNavTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        side: const BorderSide(color: AppColors.border),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

String _languageLabelText(String languageCode) {
  return languageCode == LocaleSettingsService.myanmarLanguageCode
      ? AppStrings.languageMyanmar
      : AppStrings.languageEnglish;
}
