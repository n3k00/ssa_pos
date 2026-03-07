import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class SsaApp extends ConsumerWidget {
  const SsaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final title = config.isProduction
        ? AppStrings.appName
        : '${AppStrings.appName} (${config.flavorName})';

    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
      builder: (context, child) {
        if (config.isProduction || child == null) {
          return child ?? const SizedBox.shrink();
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
