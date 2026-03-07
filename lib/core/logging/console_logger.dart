import 'dart:developer' as developer;

import 'package:ssa/core/logging/app_logger.dart';

class ConsoleLogger implements AppLogger {
  const ConsoleLogger({required this.enableDebugLogs});

  final bool enableDebugLogs;

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!enableDebugLogs) {
      return;
    }
    _log('DEBUG', message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _log('INFO', message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, error: error, stackTrace: stackTrace);
  }

  void _log(
    String level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'SSA.$level',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
