abstract class PrinterService {
  Future<List<String>> scanDevices();
  Future<bool> connect(String address);
  Future<void> printReceipt(String content);
}

class MockPrinterService implements PrinterService {
  @override
  Future<List<String>> scanDevices() async {
    return const <String>['Demo Printer'];
  }

  @override
  Future<bool> connect(String address) async {
    return true;
  }

  @override
  Future<void> printReceipt(String content) async {
    // Placeholder for bluetooth thermal printer implementation.
  }
}
