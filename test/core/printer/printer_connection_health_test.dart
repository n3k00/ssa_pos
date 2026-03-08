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
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    PrinterConnectionHealth.debugConnectionStatusReader = null;
  });

  test('refresh disconnects stale app state when plugin reports disconnected', () async {
    PrinterConnectionHealth.debugConnectionStatusReader = () async => false;

    final core = _FakePrinterCore(connected: true);
    final result = await PrinterConnectionHealth.refresh(core);

    expect(result, false);
    expect(core.disconnectCalls, 1);
  });

  test('refresh keeps state when plugin reports connected', () async {
    PrinterConnectionHealth.debugConnectionStatusReader = () async => true;

    final core = _FakePrinterCore(connected: true);
    final result = await PrinterConnectionHealth.refresh(core);

    expect(result, true);
    expect(core.disconnectCalls, 0);
  });
}
