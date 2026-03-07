import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';

class SsaApp extends StatelessWidget {
  const SsaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
