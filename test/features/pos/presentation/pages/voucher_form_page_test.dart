import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/printer/printer_connection_health.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_form_page.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_print_preview_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class _FakePrinterCore extends PrinterCore {
  _FakePrinterCore({required this.connected});

  bool connected;

  @override
  bool get hasConnectedPrinter => connected;

  @override
  Future<void> disconnect() async {
    connected = false;
  }
}

void main() {
  tearDown(() {
    PrinterConnectionHealth.debugConnectionStatusReader = null;
  });

  testWidgets('shows validation message and does not navigate on empty form', (
    tester,
  ) async {
    final core = _FakePrinterCore(connected: true);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [printerCoreProvider.overrideWith((ref) => core)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(child: VoucherFormSection()),
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.text(AppStrings.printPreview));
    await tester.tap(find.text(AppStrings.printPreview));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.fillRequiredFields), findsOneWidget);
    expect(find.byType(VoucherPrintPreviewPage), findsNothing);
  });

  testWidgets('does not navigate when printer health refresh reports disconnected', (
    tester,
  ) async {
    final core = _FakePrinterCore(connected: true);
    PrinterConnectionHealth.debugConnectionStatusReader = () async => false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [printerCoreProvider.overrideWith((ref) => core)],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(child: VoucherFormSection()),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), 'Recipient');
    await tester.enterText(find.byType(TextFormField).at(1), '0912345678');
    await tester.enterText(find.byType(TextFormField).at(2), 'Yangon');
    await tester.enterText(find.byType(TextFormField).at(3), 'fb.user');
    await tester.enterText(find.byType(TextFormField).at(4), 'P-001');
    await tester.enterText(find.byType(TextFormField).at(5), 'Payment Due');

    await tester.ensureVisible(find.text(AppStrings.printPreview));
    await tester.tap(find.text(AppStrings.printPreview));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.printerRequiredForPreview), findsOneWidget);
    expect(find.byType(VoucherPrintPreviewPage), findsNothing);
    expect(core.connected, isFalse);
  });
}
