import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/pos/presentation/pages/pos_home_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

void main() {
  testWidgets('shows bluetooth action and opens printer connect page', (tester) async {
    final core = PrinterCore();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          printerCoreInitializedProvider.overrideWith((ref) => true),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const PosHomePage(title: AppStrings.homeTitle),
        ),
      ),
    );

    expect(find.byIcon(Icons.bluetooth_searching), findsOneWidget);

    await tester.tap(find.byIcon(Icons.bluetooth_searching));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(PrinterConnectPage), findsOneWidget);
  });
}
