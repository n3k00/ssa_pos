import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.activeRoute,
  });

  final String activeRoute;

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
                child: _DrawerHeaderTitle(),
              ),
            ),
            ListTile(
              selected: activeRoute == AppRoutes.home,
              leading: const Icon(Icons.home_outlined),
              title: Text(AppStrings.home),
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
              title: Text(AppStrings.voucherList),
              onTap: () {
                Navigator.of(context).pop();
                if (activeRoute == AppRoutes.voucherList) {
                  return;
                }
                Navigator.of(context).pushNamed(AppRoutes.voucherList);
              },
            ),
            ListTile(
              selected: activeRoute == AppRoutes.printerSettings,
              leading: const Icon(Icons.settings_outlined),
              title: Text(AppStrings.printerSettings),
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

class _DrawerHeaderTitle extends StatelessWidget {
  const _DrawerHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Text(AppStrings.menu, style: AppTextStyles.headlineMedium);
  }
}
