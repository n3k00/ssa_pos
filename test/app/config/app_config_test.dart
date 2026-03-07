import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/config/app_config.dart';
import 'package:ssa/app/config/app_flavor.dart';

void main() {
  group('AppConfig.fromEnvironment', () {
    test('uses default values when defines are missing', () {
      final config = AppConfig.fromEnvironment(AppFlavor.dev);

      expect(config.flavor, AppFlavor.dev);
      expect(config.apiBaseUrl, 'https://api.example.com');
      expect(config.enableFirebaseSync, false);
      expect(config.enableBluetoothPrinting, true);
      expect(config.enableDebugTools, false);
      expect(config.flavorName, 'DEV');
      expect(config.isProduction, false);
    });

    test('marks production flavor correctly', () {
      final prodConfig = AppConfig.fromEnvironment(AppFlavor.prod);

      expect(prodConfig.isProduction, true);
      expect(prodConfig.flavorName, 'PROD');
    });
  });
}
