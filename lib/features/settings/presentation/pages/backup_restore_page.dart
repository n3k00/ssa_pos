import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/backup/local_backup_service.dart';
import 'package:ssa/features/settings/presentation/widgets/settings_editor_widgets.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class BackupRestorePage extends ConsumerStatefulWidget {
  const BackupRestorePage({super.key});

  @override
  ConsumerState<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends ConsumerState<BackupRestorePage> {
  bool _working = false;
  String _workingMessage = AppStrings.backupPreparingExport;

  ButtonStyle get _actionButtonStyle => OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(52),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimens.radius12),
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
                SettingsEditorSection(
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
