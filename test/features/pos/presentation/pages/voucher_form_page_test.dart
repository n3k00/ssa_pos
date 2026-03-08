import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_form_page.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_print_preview_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class _FakePrinterCore extends PrinterCore {
  _FakePrinterCore({required this.connected});

  bool connected;

  @override
  bool get hasConnectedPrinter => connected;
}

void main() {
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
}
