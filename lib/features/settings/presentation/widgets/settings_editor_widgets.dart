import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class SettingsEditorSection extends StatelessWidget {
  const SettingsEditorSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radius16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: AppDimens.spacing4),
          Text(subtitle, style: AppTextStyles.bodySmall),
          const SizedBox(height: AppDimens.spacing16),
          child,
        ],
      ),
    );
  }
}

class MinimalSettingsTextField extends StatelessWidget {
  const MinimalSettingsTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacing12,
        vertical: AppDimens.spacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTextStyles.bodySmall,
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
}

class MinimalSettingsSlider extends StatelessWidget {
  const MinimalSettingsSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.spacing12,
        AppDimens.spacing12,
        AppDimens.spacing12,
        AppDimens.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppTextStyles.labelLarge)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing8,
                  vertical: AppDimens.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppDimens.radius12),
                ),
                child: Text(
                  value.toStringAsFixed(0),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.divider,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withAlpha(24),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              min: min,
              max: max,
              divisions: (max - min).toInt(),
              value: value.clamp(min, max),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPresetChip extends StatelessWidget {
  const SettingsPresetChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacing12,
          vertical: AppDimens.spacing8,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryContainer : AppColors.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: selected ? AppColors.primary : AppColors.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
