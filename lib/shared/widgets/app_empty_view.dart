import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.message,
    this.icon = Icons.inbox_outlined,
  });

  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textHint, size: 40),
            const SizedBox(height: AppDimens.spacing12),
            Text(
              message ?? AppStrings.noData,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
