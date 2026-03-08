import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.activeRoute,
    this.onConnectPrinterTap,
  });

  final String activeRoute;
  final Future<void> Function()? onConnectPrinterTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  AppStrings.menu,
                  style: AppTextStyles.headlineMedium,
                ),
              ),
            ),
            ListTile(
              selected: activeRoute == AppRoutes.home,
              leading: const Icon(Icons.home_outlined),
              title: const Text(AppStrings.home),
              onTap: () {
                Navigator.of(context).pop();
                if (activeRoute == AppRoutes.home) {
                  return;
                }
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
              },
            ),
            ListTile(
              selected: activeRoute == AppRoutes.voucherList,
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text(AppStrings.voucherList),
              onTap: () {
                Navigator.of(context).pop();
                if (activeRoute == AppRoutes.voucherList) {
                  return;
                }
                Navigator.of(context).pushNamed(AppRoutes.voucherList);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bluetooth_searching),
              title: const Text(AppStrings.connectPrinter),
              onTap: () async {
                Navigator.of(context).pop();
                if (onConnectPrinterTap != null) {
                  await onConnectPrinterTap!();
                  return;
                }
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
              },
            ),
            ListTile(
              selected: activeRoute == AppRoutes.printerSettings,
              leading: const Icon(Icons.settings_outlined),
              title: const Text(AppStrings.printerSettings),
              onTap: () {
                Navigator.of(context).pop();
                if (activeRoute == AppRoutes.printerSettings) {
                  return;
                }
                Navigator.of(context).pushNamed(AppRoutes.printerSettings);
              },
            ),
          ],
        ),
      ),
    );
  }
}
