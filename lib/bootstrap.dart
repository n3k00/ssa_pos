import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/app.dart';
import 'package:ssa/app/config/app_config.dart';
import 'package:ssa/app/config/app_flavor.dart';
import 'package:ssa/shared/providers/app_providers.dart';

void bootstrap(AppFlavor flavor) {
  final appConfig = AppConfig.fromEnvironment(flavor);
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(appConfig),
    ],
  );
  final logger = container.read(appLoggerProvider);

  FlutterError.onError = (details) {
    logger.error(
      'Flutter framework error',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error('Platform error', error: error, stackTrace: stack);
    return true;
  };

  runZonedGuarded(
    () {
      logger.info('Bootstrap start (${appConfig.flavorName})');
      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const SsaApp(),
        ),
      );
    },
    (error, stack) {
      logger.error('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}
