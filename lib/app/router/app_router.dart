import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/pos/presentation/pages/pos_home_page.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_form_page.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_list_page.dart';
import 'package:ssa/features/settings/presentation/pages/printer_settings_page.dart';

class AppRoutes {
  static const home = '/';
  static const voucherForm = '/voucher-form';
  static const voucherList = '/voucher-list';
  static const printerSettings = '/printer-settings';

  const AppRoutes._();
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.voucherList:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const VoucherListPage(),
        );
      case AppRoutes.printerSettings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const PrinterSettingsPage(),
        );
      case AppRoutes.voucherForm:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const VoucherFormPage(),
        );
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
