import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/features/settings/presentation/pages/printer_settings_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class _FakeReceiptSettingsService extends ReceiptSettingsService {
  const _FakeReceiptSettingsService({required this.shouldSaveSucceed});

  final bool shouldSaveSucceed;

  @override
  Future<ReceiptSettings> load({
    required String defaultTitle,
    required String defaultPhones,
    required double defaultTitleFontSize,
    required double defaultPhonesFontSize,
    required double defaultRowFontSize,
    required double defaultPaddingTop,
    required double defaultPaddingHorizontal,
    required double defaultPaddingBottom,
    required PrintDensityPreset defaultPrintDensityPreset,
    required int defaultFeedLinesAfterPrint,
  }) async {
    return ReceiptSettings(
      title: defaultTitle,
      phones: defaultPhones,
      titleFontSize: defaultTitleFontSize,
      phonesFontSize: defaultPhonesFontSize,
      rowFontSize: defaultRowFontSize,
      paddingTop: defaultPaddingTop,
      paddingHorizontal: defaultPaddingHorizontal,
      paddingBottom: defaultPaddingBottom,
      printDensityPreset: defaultPrintDensityPreset,
      feedLinesAfterPrint: defaultFeedLinesAfterPrint,
    );
  }

  @override
  Future<bool> save({
    required String title,
    required String phones,
    required double titleFontSize,
    required double phonesFontSize,
    required double rowFontSize,
    required double paddingTop,
    required double paddingHorizontal,
    required double paddingBottom,
    required PrintDensityPreset printDensityPreset,
    required int feedLinesAfterPrint,
  }) async {
    return shouldSaveSucceed;
  }
}

void main() {
  testWidgets('shows failure snackbar when settings save fails', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          receiptSettingsServiceProvider.overrideWithValue(
            const _FakeReceiptSettingsService(shouldSaveSucceed: false),
          ),
        ],
        child: MaterialApp(
          home: const PrinterSettingsPage(),
          theme: AppTheme.light,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.receiptHeaderSettings));
    await tester.pumpAndSettle();

    final editorContext = tester.element(find.byType(Scaffold).last);
    Navigator.of(editorContext).pop(
      const ReceiptSettings(
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
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.settingsSaveFailed), findsOneWidget);
    expect(find.text(AppStrings.settingsSaved), findsNothing);
  });
}
