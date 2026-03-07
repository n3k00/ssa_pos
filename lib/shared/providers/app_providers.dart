import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/config/app_config.dart';
import 'package:ssa/app/config/app_flavor.dart';
import 'package:ssa/core/db/app_database.dart';
import 'package:ssa/core/logging/app_logger.dart';
import 'package:ssa/core/logging/console_logger.dart';
import 'package:ssa/core/network/connectivity_service.dart';
import 'package:ssa/core/printer/printer_service.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment(AppFlavor.prod);
});

final appLoggerProvider = Provider<AppLogger>((ref) {
  final config = ref.watch(appConfigProvider);
  return ConsoleLogger(enableDebugLogs: config.enableDebugTools);
});

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final printerServiceProvider = Provider<PrinterService>((ref) {
  return MockPrinterService();
});

final printerCoreProvider = ChangeNotifierProvider<PrinterCore>((ref) {
  final core = PrinterCore();
  core.scanTimeout = const Duration(seconds: 4);
  return core;
});

final printerCoreInitializedProvider = StateProvider<bool>((ref) => false);
