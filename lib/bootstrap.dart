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
  ProviderContainer? container;

  void logBootstrapError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final currentContainer = container;
    if (currentContainer != null) {
      currentContainer.read(
        appLoggerProvider,
      ).error(message, error: error, stackTrace: stackTrace);
      return;
    }

    debugPrint(message);
    if (error != null) {
      debugPrint(error.toString());
    }
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }

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
      final logger = container!.read(appLoggerProvider);

      FlutterError.onError = (details) {
        logBootstrapError(
          'Flutter framework error',
          error: details.exception,
          stackTrace: details.stack,
        );
        FlutterError.presentError(details);
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        logBootstrapError('Platform error', error: error, stackTrace: stack);
        return true;
      };

      logger.info('Bootstrap start (${appConfig.flavorName})');
      runApp(
        UncontrolledProviderScope(
          container: container!,
          child: const SsaApp(),
        ),
      );
    },
    (error, stack) {
      logBootstrapError(
        'Uncaught zone error',
        error: error,
        stackTrace: stack,
      );
    },
  );
}
