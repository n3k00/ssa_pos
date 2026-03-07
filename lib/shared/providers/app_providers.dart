import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/core/db/app_database.dart';
import 'package:ssa/core/network/connectivity_service.dart';
import 'package:ssa/core/printer/printer_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

final printerServiceProvider = Provider<PrinterService>((ref) {
  return MockPrinterService();
});
