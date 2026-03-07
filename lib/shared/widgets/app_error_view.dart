import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    this.message = AppStrings.errorGeneric,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: AppDimens.spacing12),
            Text(
              message,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimens.spacing16),
              SizedBox(
                width: 160,
                child: ElevatedButton(
                  onPressed: onRetry,
                  child: const Text(AppStrings.retry),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
