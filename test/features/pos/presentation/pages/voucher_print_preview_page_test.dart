import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/printer/printer_connection_health.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_print_preview_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class _FakePrinterCore extends PrinterCore {
  _FakePrinterCore({
    required this.connected,
    required this.printResult,
  });

  bool connected;
  bool printResult;

  @override
  bool get hasConnectedPrinter => connected;

  @override
  Future<bool> printImage(
    Uint8List imageBytes, {
    PrinterPrintConfig config = const PrinterPrintConfig(),
  }) async {
    return printResult;
  }

  @override
  Future<void> disconnect() async {
    connected = false;
  }
}

class _FakeVoucherRepository implements VoucherRepository {
  int createCalls = 0;
  int updateCalls = 0;
  Voucher? latestVoucher;
  Voucher? lastUpdatedVoucher;

  @override
  Future<void> create(Voucher voucher) async {
    createCalls++;
    latestVoucher = voucher;
  }

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Voucher>> getAll({int limit = 50, int offset = 0}) async {
    return const <Voucher>[];
  }

  @override
  Future<Voucher?> getById(String id) async {
    return latestVoucher;
  }

  @override
  Future<List<Voucher>> search(String query, {int limit = 50, int offset = 0}) {
    return Future.value(const <Voucher>[]);
  }

  @override
  Future<void> update(Voucher voucher) async {
    updateCalls++;
    lastUpdatedVoucher = voucher;
    latestVoucher = voucher;
  }
}

class _Launcher extends StatelessWidget {
  const _Launcher({required this.previewPage});

  final Widget previewPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => previewPage));
          },
          child: const Text('Open'),
        ),
      ),
    );
  }
}

Voucher _sampleVoucher() {
  final now = DateTime(2026, 3, 8, 10, 0);
  return Voucher(
    id: 'v-1',
    createdAt: now,
    updatedAt: now,
    dateAndTime: now.toIso8601String(),
    paymentStatus: 'payment_due',
    name: 'Recipient',
    phone: '09999999',
    address: 'Address',
    facebookAccount: null,
    parcelNumber: 'P-001',
    note: null,
    itemImagePath: null,
    dispatchReceiptImagePath: null,
    dispatchReceiptSavedAt: null,
  );
}

Voucher _sampleVoucherWithPaymentStatus(String paymentStatus) {
  final voucher = _sampleVoucher();
  return voucher.copyWith(paymentStatus: paymentStatus);
}

void main() {
  setUp(() {
    PrinterConnectionHealth.debugConnectionStatusReader = () async => true;
  });

  tearDown(() {
    PrinterConnectionHealth.debugConnectionStatusReader = null;
  });

  testWidgets('does not save when printing fails', (tester) async {
    final core = _FakePrinterCore(connected: true, printResult: false);
    final repo = _FakeVoucherRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          voucherRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: _Launcher(
            previewPage: VoucherPrintPreviewPage(
              voucher: _sampleVoucher(),
              captureReceiptBytes: () async => Uint8List.fromList(<int>[1, 2, 3]),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.printAndSave));
    await tester.pumpAndSettle();

    expect(repo.createCalls, 0);
    expect(find.text(AppStrings.previewTitle), findsOneWidget);
  });

  testWidgets('saves after successful print', (tester) async {
    final core = _FakePrinterCore(connected: true, printResult: true);
    final repo = _FakeVoucherRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          voucherRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: _Launcher(
            previewPage: VoucherPrintPreviewPage(
              voucher: _sampleVoucher(),
              captureReceiptBytes: () async => Uint8List.fromList(<int>[1, 2, 3]),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.printAndSave));
    await tester.pumpAndSettle();

    expect(repo.createCalls, 1);
    expect(find.text(AppStrings.previewTitle), findsNothing);
  });

  testWidgets('does not print when health refresh reports disconnected', (
    tester,
  ) async {
    final core = _FakePrinterCore(connected: true, printResult: true);
    final repo = _FakeVoucherRepository();
    PrinterConnectionHealth.debugConnectionStatusReader = () async => false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          voucherRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: _Launcher(
            previewPage: VoucherPrintPreviewPage(
              voucher: _sampleVoucher(),
              captureReceiptBytes: () async => Uint8List.fromList(<int>[1, 2, 3]),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.printAndSave));
    await tester.pumpAndSettle();

    expect(repo.createCalls, 0);
    expect(find.text(AppStrings.printerNotConnected), findsOneWidget);
    expect(core.connected, isFalse);
  });

  testWidgets('shows custom payment status text as entered', (tester) async {
    final core = _FakePrinterCore(connected: true, printResult: true);
    final repo = _FakeVoucherRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          printerCoreProvider.overrideWith((ref) => core),
          voucherRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: _Launcher(
            previewPage: VoucherPrintPreviewPage(
              voucher: _sampleVoucherWithPaymentStatus('Half paid, collect later'),
              captureReceiptBytes: () async => Uint8List.fromList(<int>[1, 2, 3]),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Half paid, collect later'), findsOneWidget);
  });
}
