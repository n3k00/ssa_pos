import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/settings/locale_settings_service.dart';
import 'package:ssa/shared/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSettingsPage extends ConsumerWidget {
  const LanguageSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);

    Future<void> onSelect(String languageCode) async {
      final saved = await ref
          .read(localeControllerProvider.notifier)
          .setLanguageCode(languageCode);
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            saved ? AppStrings.languageUpdated : AppStrings.settingsSaveFailed,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.languageSettings)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        children: [
          _LanguageTile(
            title: AppStrings.languageEnglish,
            selected:
                locale.languageCode == LocaleSettingsService.defaultLanguageCode,
            onTap: () => onSelect(LocaleSettingsService.defaultLanguageCode),
          ),
          const SizedBox(height: AppDimens.spacing12),
          _LanguageTile(
            title: AppStrings.languageMyanmar,
            selected:
                locale.languageCode == LocaleSettingsService.myanmarLanguageCode,
            onTap: () => onSelect(LocaleSettingsService.myanmarLanguageCode),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        side: const BorderSide(color: AppColors.border),
      ),
      title: Text(title),
      trailing: selected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: onTap,
    );
  }
}
