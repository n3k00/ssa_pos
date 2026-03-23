import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/app.dart';
import 'package:ssa/app/config/app_config.dart';
import 'package:ssa/app/config/app_flavor.dart';
import 'package:ssa/shared/providers/app_providers.dart';

Future<void> bootstrap(AppFlavor flavor) async {
  late final ProviderContainer container;

  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();

      final appConfig = AppConfig.fromEnvironment(flavor);
      container = ProviderContainer(
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

      logger.info('Bootstrap start (${appConfig.flavorName})');
      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const SsaApp(),
        ),
      );
    },
    (error, stack) {
      final logger = container.read(appLoggerProvider);
      logger.error('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}
