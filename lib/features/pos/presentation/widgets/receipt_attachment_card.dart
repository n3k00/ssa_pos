import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class AttachmentAction {
  const AttachmentAction({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;
}

class ReceiptAttachmentCard extends StatelessWidget {
  const ReceiptAttachmentCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.width,
    required this.height,
    required this.onTap,
    this.primaryAction,
    this.secondaryAction,
    this.footer,
    this.emptyStateLabel,
  });

  final String title;
  final String subtitle;
  final String? imagePath;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final AttachmentAction? primaryAction;
  final AttachmentAction? secondaryAction;
  final Widget? footer;
  final String? emptyStateLabel;

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null && imagePath!.isNotEmpty;
    final hasAccessibleImage =
        hasImage && File(imagePath!).existsSync();

    return Container(
      padding: const EdgeInsets.all(AppDimens.spacing10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.labelLarge),
                    const SizedBox(height: AppDimens.spacing2),
                    Text(subtitle, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              if (primaryAction != null)
                _OverlayActionIcon(
                  icon: primaryAction!.icon,
                  onTap: primaryAction!.onTap,
                ),
              if (secondaryAction != null) ...[
                const SizedBox(width: AppDimens.spacing8),
                _OverlayActionIcon(
                  icon: secondaryAction!.icon,
                  onTap: secondaryAction!.onTap,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimens.spacing10),
          if (hasAccessibleImage)
            _PreviewImageCard(
              imagePath: imagePath!,
              width: width,
              height: height,
              onTap: onTap!,
            )
          else
            _AttachmentPlaceholder(
              width: width,
              height: height,
              label: emptyStateLabel ?? title,
              onTap: primaryAction?.onTap,
            ),
          if (footer != null) ...[
            const SizedBox(height: AppDimens.spacing10),
            footer!,
          ],
        ],
      ),
    );
  }
}

class _OverlayActionIcon extends StatelessWidget {
  const _OverlayActionIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.black.withAlpha(115),
      borderRadius: BorderRadius.circular(AppDimens.radius8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radius8),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacing8),
          child: Icon(icon, color: AppColors.white, size: AppDimens.icon20),
        ),
      ),
    );
  }
}

class _AttachmentPlaceholder extends StatelessWidget {
  const _AttachmentPlaceholder({
    required this.width,
    required this.height,
    required this.label,
    this.onTap,
  });

  final double width;
  final double height;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radius12),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radius12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: AppDimens.icon28,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppDimens.spacing8),
            Text(label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _PreviewImageCard extends StatelessWidget {
  const _PreviewImageCard({
    required this.imagePath,
    required this.width,
    required this.height,
    required this.onTap,
  });

  final String imagePath;
  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radius12),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppDimens.radius12),
          ),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.surface,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image_outlined,
                  size: AppDimens.icon28,
                  color: AppColors.textHint,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
