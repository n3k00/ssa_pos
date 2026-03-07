import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/pos/presentation/pages/pos_home_page.dart';

class AppRoutes {
  static const home = '/';

  const AppRoutes._();
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
      default:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PosHomePage(title: AppStrings.homeTitle),
        );
    }
  }

  const AppRouter._();
}
