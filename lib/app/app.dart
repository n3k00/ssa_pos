import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_navigation.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/l10n/app_localizations.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class SsaApp extends ConsumerWidget {
  const SsaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      onGenerateTitle: (context) {
        final l10n = AppLocalizations.of(context)!;
        final appName = l10n.appName;
        return config.isProduction ? appName : '$appName (${config.flavorName})';
      },
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        if (child == null) {
          return const SizedBox.shrink();
        }

        if (config.isProduction) {
          return child;
        }

        return Banner(
          message: config.flavorName,
          location: BannerLocation.topEnd,
          color: AppColors.warning,
          textStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          child: child,
        );
      },
    );
  }
}
