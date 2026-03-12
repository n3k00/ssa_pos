import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/permissions/bluetooth_permission_service.dart';
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

void main() {
  testWidgets('opens printer connect page from app bar button', (tester) async {
    final core = PrinterCore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          printerCoreInitializedProvider.overrideWith((ref) => true),
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
