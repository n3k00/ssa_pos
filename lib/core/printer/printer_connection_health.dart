import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrinterConnectionHealth {
  const PrinterConnectionHealth._();

  static Future<bool> Function()? debugConnectionStatusReader;

  static Future<bool> refresh(PrinterCore core) async {
    final isActuallyConnected =
        await (debugConnectionStatusReader?.call() ??
            PrintBluetoothThermal.connectionStatus);
    if (!isActuallyConnected && core.hasConnectedPrinter) {
      await core.disconnect();
    }
    return isActuallyConnected;
  }
}
