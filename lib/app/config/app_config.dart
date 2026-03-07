import 'package:ssa/app/config/app_flavor.dart';

class AppConfig {
  const AppConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.enableFirebaseSync,
    required this.enableBluetoothPrinting,
    required this.enableDebugTools,
  });

  final AppFlavor flavor;
  final String apiBaseUrl;
  final bool enableFirebaseSync;
  final bool enableBluetoothPrinting;
  final bool enableDebugTools;

  bool get isProduction => flavor == AppFlavor.prod;

  String get flavorName => flavor.name.toUpperCase();

  factory AppConfig.fromEnvironment(AppFlavor flavor) {
    return AppConfig(
      flavor: flavor,
      apiBaseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'https://api.example.com',
      ),
      enableFirebaseSync: const bool.fromEnvironment(
        'FEATURE_FIREBASE_SYNC',
        defaultValue: false,
      ),
      enableBluetoothPrinting: const bool.fromEnvironment(
        'FEATURE_BLUETOOTH_PRINTING',
        defaultValue: true,
      ),
      enableDebugTools: const bool.fromEnvironment(
        'FEATURE_DEBUG_TOOLS',
        defaultValue: false,
      ),
    );
  }
}
