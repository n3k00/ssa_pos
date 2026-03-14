import 'package:flutter/material.dart';
import 'package:ssa/app/design_system.dart';

class ReceiptPreviewRowData {
  const ReceiptPreviewRowData({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class ReceiptPreviewCard extends StatelessWidget {
  const ReceiptPreviewCard({
    super.key,
    required this.width,
    required this.title,
    required this.phones,
    required this.titleFontSize,
    required this.phonesFontSize,
    required this.rowFontSize,
    required this.paddingTop,
    required this.paddingHorizontal,
    required this.paddingBottom,
    required this.rows,
    this.showBorder = true,
    this.borderRadius = 0,
  });

  final double width;
  final String title;
  final String phones;
  final double titleFontSize;
  final double phonesFontSize;
  final double rowFontSize;
  final double paddingTop;
  final double paddingHorizontal;
  final double paddingBottom;
  final List<ReceiptPreviewRowData> rows;
  final bool showBorder;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        top: paddingTop,
        left: paddingHorizontal,
        right: paddingHorizontal,
        bottom: paddingBottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: showBorder ? Border.all(color: AppColors.border) : null,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimens.spacing4),
          Center(
            child: Text(
              phones,
              style: AppTextStyles.titleMedium.copyWith(
                fontSize: phonesFontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimens.spacing8),
          const Divider(height: 1, color: AppColors.divider),
          for (final row in rows)
            ReceiptPreviewRow(
              label: row.label,
              value: row.value,
              fontSize: rowFontSize,
            ),
        ],
      ),
    );
  }
}

class ReceiptPreviewRow extends StatelessWidget {
  const ReceiptPreviewRow({
    super.key,
    required this.label,
    required this.value,
    required this.fontSize,
  });

  final String label;
  final String value;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacing8),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}
