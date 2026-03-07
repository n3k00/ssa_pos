import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class PosHomePage extends StatelessWidget {
  const PosHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Padding(
        padding: EdgeInsets.all(AppDimens.pagePadding),
        child: Text(
          AppStrings.posReadyMessage,
          style: AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}
