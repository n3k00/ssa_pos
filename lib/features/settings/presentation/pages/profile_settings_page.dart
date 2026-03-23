import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/features/auth/presentation/providers/auth_providers.dart';
import 'package:ssa/features/pos/presentation/models/voucher_sync_state.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final phoneNumber =
        authRepository.currentPhoneNumber() ?? AppStrings.noData;
    final syncState = ref.watch(voucherSyncControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profileSettings)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        children: [
          _InfoTile(
            title: AppStrings.phoneNumberLabel,
            subtitle: phoneNumber,
            leading: Icons.phone_outlined,
          ),
          const SizedBox(height: AppDimens.spacing12),
          _InfoTile(
            title: AppStrings.lastSyncTimeLabel,
            subtitle: _formatLastSync(syncState.lastSyncedAt),
            leading: Icons.history_toggle_off_outlined,
          ),
          const SizedBox(height: AppDimens.spacing12),
          _InfoTile(
            title: AppStrings.syncStatusLabel,
            subtitle: _syncStatusLabel(syncState),
            leading: Icons.cloud_done_outlined,
            trailing: syncState.isSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          const SizedBox(height: AppDimens.spacing16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: syncState.isSyncing
                  ? null
                  : () => ref.read(voucherSyncServiceProvider).syncIfAuthenticated(),
              icon: const Icon(Icons.sync),
              label: Text(
                syncState.isSyncing
                    ? AppStrings.syncingNow
                    : AppStrings.syncNow,
              ),
            ),
          ),
          if (syncState.hasFailure &&
              syncState.errorMessage != null &&
              syncState.errorMessage!.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spacing12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing4),
              child: Text(
                syncState.errorMessage!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spacing24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) {
                    return AlertDialog(
                      title: Text(AppStrings.logoutConfirmTitle),
                      content: Text(AppStrings.logoutConfirmMessage),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: Text(AppStrings.no),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: Text(AppStrings.yes),
                        ),
                      ],
                    );
                  },
                );
                if (shouldLogout != true || !context.mounted) {
                  return;
                }
                await authRepository.signOut();
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout),
              label: Text(AppStrings.logout),
            ),
          ),
        ],
      ),
    );
  }

  String _syncStatusLabel(VoucherSyncState state) {
    if (state.isSyncing) {
      return AppStrings.syncingNow;
    }
    if (state.hasFailure) {
      return AppStrings.syncFailed;
    }
    if (state.lastSyncedAt != null) {
      return AppStrings.syncReady;
    }
    return AppStrings.syncNotStarted;
  }

  String _formatLastSync(DateTime? value) {
    if (value == null) {
      return AppStrings.syncNever;
    }
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour12 = (local.hour % 12 == 0 ? 12 : local.hour % 12)
        .toString()
        .padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final amPm = local.hour >= 12 ? 'PM' : 'AM';
    return '$day-$month-$year $hour12:$minute $amPm';
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.subtitle,
    required this.leading,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final IconData leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        side: const BorderSide(color: AppColors.border),
      ),
      leading: Icon(leading, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }
}
