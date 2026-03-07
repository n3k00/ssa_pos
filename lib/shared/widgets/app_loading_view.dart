import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({
    super.key,
    this.message = AppStrings.loading,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppDimens.spacing12),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
