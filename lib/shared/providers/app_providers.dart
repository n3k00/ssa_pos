import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/config/app_config.dart';
import 'package:ssa/app/config/app_flavor.dart';
import 'package:ssa/core/backup/local_backup_service.dart';
import 'package:ssa/core/db/app_database.dart';
import 'package:ssa/core/device/device_id_service.dart';
import 'package:ssa/core/storage/local_image_storage_service.dart';
import 'package:ssa/core/sync/voucher_sync_status_service.dart';
import 'package:ssa/features/pos/data/repositories/firebase_voucher_cloud_repository.dart';
import 'package:ssa/features/pos/data/datasources/voucher_image_local_datasource.dart';
import 'package:ssa/features/pos/data/datasources/voucher_local_datasource.dart';
import 'package:ssa/features/pos/data/repositories/voucher_repository_impl.dart';
import 'package:ssa/features/pos/presentation/controllers/voucher_sync_controller.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_cloud_repository.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';
import 'package:ssa/features/pos/domain/services/voucher_sync_service.dart';
import 'package:ssa/core/logging/app_logger.dart';
import 'package:ssa/core/logging/console_logger.dart';
import 'package:ssa/core/network/connectivity_service.dart';
import 'package:ssa/core/permissions/bluetooth_permission_service.dart';
import 'package:ssa/core/printer/printer_service.dart';
import 'package:ssa/core/settings/locale_settings_service.dart';
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/features/pos/presentation/models/voucher_sync_state.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment(AppFlavor.prod);
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final config = ref.watch(appConfigProvider);
  return ConsoleLogger(enableDebugLogs: config.enableDebugTools);
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final bluetoothPermissionClientProvider = Provider<BluetoothPermissionClient>((
  ref,
) {
  return DefaultBluetoothPermissionClient();
});

final printerServiceProvider = Provider<PrinterService>((ref) {
  return MockPrinterService();
});

final printerCoreProvider = ChangeNotifierProvider<PrinterCore>((ref) {
  final core = PrinterCore();
  core.scanTimeout = const Duration(seconds: 4);
  return core;
});

final printerCoreInitializedProvider = StateProvider<bool>((ref) => false);

final voucherLocalDataSourceProvider = Provider<VoucherLocalDataSource>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return VoucherLocalDataSource(database);
});

final voucherRepositoryProvider = Provider<VoucherRepository>((ref) {
  final localDataSource = ref.watch(voucherLocalDataSourceProvider);
  return VoucherRepositoryImpl(localDataSource);
});

final voucherCloudRepositoryProvider = Provider<VoucherCloudRepository>((ref) {
  return FirebaseVoucherCloudRepository(
    firestore: ref.watch(firebaseFirestoreProvider),
    auth: ref.watch(firebaseAuthProvider),
  );
});

final deviceIdServiceProvider = Provider<DeviceIdService>((ref) {
  return const DeviceIdService();
});

final voucherSyncStatusServiceProvider = Provider<VoucherSyncStatusService>((ref) {
  return const VoucherSyncStatusService();
});

final voucherSyncControllerProvider =
    StateNotifierProvider<VoucherSyncController, VoucherSyncState>((ref) {
      final controller = VoucherSyncController(
        ref.watch(voucherSyncStatusServiceProvider),
      );
      controller.loadSavedState();
      return controller;
    });

final voucherSyncServiceProvider = Provider<VoucherSyncService>((ref) {
  final syncController = ref.watch(voucherSyncControllerProvider.notifier);
  return VoucherSyncService(
    voucherRepository: ref.watch(voucherRepositoryProvider),
    voucherCloudRepository: ref.watch(voucherCloudRepositoryProvider),
    deviceIdService: ref.watch(deviceIdServiceProvider),
    currentUserId: () => ref.read(firebaseAuthProvider).currentUser?.uid,
    logger: ref.watch(appLoggerProvider),
    onSyncStarted: syncController.markSyncing,
    onSyncSucceeded: syncController.markSuccess,
    onSyncFailed: syncController.markFailure,
  );
});

final localImageStorageServiceProvider = Provider<LocalImageStorageService>((
  ref,
) {
  return LocalImageStorageService();
});

final receiptSettingsServiceProvider = Provider<ReceiptSettingsService>((ref) {
  return const ReceiptSettingsService();
});

final localeSettingsServiceProvider = Provider<LocaleSettingsService>((ref) {
  return const LocaleSettingsService();
});

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
      final controller = LocaleController(
        ref.watch(localeSettingsServiceProvider),
      );
      controller.loadSavedLocale();
      return controller;
    });

final localBackupServiceProvider = Provider<LocalBackupService>((ref) {
  return const LocalBackupService();
});

final voucherImageLocalDataSourceProvider = Provider<VoucherImageLocalDataSource>(
  (ref) {
    final storageService = ref.watch(localImageStorageServiceProvider);
    return VoucherImageLocalDataSource(storageService: storageService);
  },
);

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._service)
    : super(const Locale(LocaleSettingsService.defaultLanguageCode));

  final LocaleSettingsService _service;

  Future<void> loadSavedLocale() async {
    final languageCode = await _service.loadLanguageCode();
    if (state.languageCode == languageCode) {
      return;
    }
    state = Locale(languageCode);
  }

  Future<bool> setLanguageCode(String languageCode) async {
    final saved = await _service.saveLanguageCode(languageCode);
    if (saved) {
      state = Locale(languageCode);
    }
    return saved;
  }
}
