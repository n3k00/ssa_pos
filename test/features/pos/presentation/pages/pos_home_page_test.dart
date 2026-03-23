import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/device/device_id_service.dart';
import 'package:ssa/core/logging/app_logger.dart';
import 'package:ssa/core/permissions/bluetooth_permission_service.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_cloud_repository.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';
import 'package:ssa/features/pos/domain/services/voucher_sync_service.dart';
import 'package:ssa/features/pos/presentation/pages/pos_home_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class _FakePermissionClient implements BluetoothPermissionClient {
  _FakePermissionClient(this.result);

  final BluetoothPermissionResult result;

  @override
  Future<BluetoothPermissionResult> ensureGranted() async => result;

  @override
  Future<bool> hasRequiredPermissions() async =>
      result == BluetoothPermissionResult.granted;
}

class _NoopVoucherRepository implements VoucherRepository {
  @override
  Future<void> create(Voucher voucher) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Voucher>> getAll({int limit = 50, int offset = 0}) async =>
      const <Voucher>[];

  @override
  Future<Voucher?> getById(String id) async => null;

  @override
  Future<List<Voucher>> getPendingSync({int limit = 100}) async =>
      const <Voucher>[];

  @override
  Future<List<Voucher>> search(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async => const <Voucher>[];

  @override
  Future<void> update(Voucher voucher) async {}
}

class _NoopVoucherCloudRepository implements VoucherCloudRepository {
  @override
  Future<List<Voucher>> fetchAll() async => const <Voucher>[];

  @override
  Future<void> upsert(Voucher voucher, {required String deviceId}) async {}
}

class _NoopDeviceIdService extends DeviceIdService {
  @override
  Future<String> getOrCreateDeviceId() async => 'test-device';
}

class _NoopLogger implements AppLogger {
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {}
}

VoucherSyncService _noopSyncService() {
  return VoucherSyncService(
    voucherRepository: _NoopVoucherRepository(),
    voucherCloudRepository: _NoopVoucherCloudRepository(),
    deviceIdService: _NoopDeviceIdService(),
    currentUserId: () => null,
    logger: _NoopLogger(),
    onSyncStarted: () {},
    onSyncSucceeded: (_) async {},
    onSyncFailed: (_) {},
  );
}

void main() {
  testWidgets('opens printer connect page from app bar button', (tester) async {
    final core = PrinterCore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          printerCoreInitializedProvider.overrideWith((ref) => true),
          voucherSyncServiceProvider.overrideWithValue(_noopSyncService()),
          bluetoothPermissionClientProvider.overrideWithValue(
            _FakePermissionClient(BluetoothPermissionResult.granted),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const PosHomePage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.bluetooth_searching));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(PrinterConnectPage), findsOneWidget);
  });

  testWidgets('shows snackbar when permission denied', (tester) async {
    final core = PrinterCore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          voucherSyncServiceProvider.overrideWithValue(_noopSyncService()),
          bluetoothPermissionClientProvider.overrideWithValue(
            _FakePermissionClient(BluetoothPermissionResult.denied),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const PosHomePage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.bluetooth_searching));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.bluetoothPermissionRequired), findsOneWidget);
  });

  testWidgets('shows settings dialog when permission permanently denied', (
    tester,
  ) async {
    final core = PrinterCore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          voucherSyncServiceProvider.overrideWithValue(_noopSyncService()),
          bluetoothPermissionClientProvider.overrideWithValue(
            _FakePermissionClient(BluetoothPermissionResult.permanentlyDenied),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const PosHomePage(),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.bluetooth_searching));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.permissionSettingsTitle), findsOneWidget);
    expect(find.text(AppStrings.openSettings), findsOneWidget);
  });
}
