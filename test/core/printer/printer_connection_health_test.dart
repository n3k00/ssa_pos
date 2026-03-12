import 'package:flutter_test/flutter_test.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/core/printer/printer_connection_health.dart';

class _FakePrinterCore extends PrinterCore {
  _FakePrinterCore({required this.connected});

  bool connected;
  int disconnectCalls = 0;

  @override
  bool get hasConnectedPrinter => connected;

  @override
  Future<void> disconnect() async {
    disconnectCalls++;
    connected = false;
  }
}

void main() {
  tearDown(() {
    PrinterConnectionHealth.debugConnectionStatusReader = null;
  });

  test('refresh disconnects stale app state when plugin reports disconnected', () async {
    final core = _FakePrinterCore(connected: true);
    PrinterConnectionHealth.debugConnectionStatusReader = () async => false;

    final result = await PrinterConnectionHealth.refresh(core);

    expect(result, isFalse);
    expect(core.disconnectCalls, 1);
    expect(core.connected, isFalse);
  });

  test('refresh keeps state when plugin reports connected', () async {
    final core = _FakePrinterCore(connected: true);
    PrinterConnectionHealth.debugConnectionStatusReader = () async => true;

    final result = await PrinterConnectionHealth.refresh(core);

    expect(result, isTrue);
    expect(core.disconnectCalls, 0);
    expect(core.connected, isTrue);
  });
}
