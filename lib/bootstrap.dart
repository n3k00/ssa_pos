import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/app.dart';
import 'package:ssa/app/config/app_config.dart';
import 'package:ssa/app/config/app_flavor.dart';
import 'package:ssa/shared/providers/app_providers.dart';

void bootstrap(AppFlavor flavor) {
  final appConfig = AppConfig.fromEnvironment(flavor);
  runApp(
    ProviderScope(
    overrides: [
      appConfigProvider.overrideWithValue(appConfig),
    ],
      child: const SsaApp(),
    ),
  );
}
