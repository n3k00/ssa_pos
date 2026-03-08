import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/printer/printer_connection_health.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class VoucherPrintPreviewPage extends ConsumerStatefulWidget {
  const VoucherPrintPreviewPage({
    super.key,
    required this.voucher,
    this.popOnSave = false,
    this.saveBeforePrint = true,
    this.captureReceiptBytes,
  });

  final Voucher voucher;
  final bool popOnSave;
  final bool saveBeforePrint;
  final Future<Uint8List?> Function()? captureReceiptBytes;

  @override
  ConsumerState<VoucherPrintPreviewPage> createState() =>
      _VoucherPrintPreviewPageState();
}

class _VoucherPrintPreviewPageState
    extends ConsumerState<VoucherPrintPreviewPage> {
  static const double _receiptPreviewWidth = 288;
  final GlobalKey _receiptBoundaryKey = GlobalKey();
  bool _saving = false;

  String _paymentStatusText(String code) {
    return code == 'payment_paid'
        ? AppStrings.paymentStatusPaid
        : AppStrings.paymentStatusDue;
  }

  String _formatDateTime(String iso) {
    final date = DateTime.tryParse(iso);
    if (date == null) {
      return iso;
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour12 = (date.hour % 12 == 0 ? 12 : date.hour % 12)
        .toString()
        .padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$day-$month-$year $hour12:$minute $amPm';
  }

  Future<void> _confirmAndSave() async {
    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final printerCore = ref.read(printerCoreProvider);
      final isConnected = await PrinterConnectionHealth.refresh(printerCore);
      if (!isConnected) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.printerNotConnected)),
        );
        return;
      }

      final imageBytes =
          await (widget.captureReceiptBytes?.call() ??
              _captureReceiptImageBytes());
      if (imageBytes == null) {
        throw StateError('Could not capture receipt image.');
      }
      final processedBytes = _trimWhiteBorders(imageBytes) ?? imageBytes;

      final printed = await printerCore.printImage(
        processedBytes,
        config: const PrinterPrintConfig(
          width: 576,
          ditherMode: PrinterDitherMode.threshold,
          threshold: 180,
          chunkDelayMs: 6,
          maxChunkSize: 220,
          feedLinesAfterPrint: 0,
          preferWriteWithoutResponse: false,
        ),
      );
      if (!mounted) {
        return;
      }
      if (!widget.saveBeforePrint) {
        setState(() {
          _saving = false;
        });
        Navigator.of(context).pop(printed);
        return;
      }
      if (!printed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.voucherPrintFailedNotSaved)),
        );
        return;
      }

      final repository = ref.read(voucherRepositoryProvider);
      await repository.create(widget.voucher);
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.voucherSavedAndPrinted)),
      );
      if (widget.popOnSave) {
        setState(() {
          _saving = false;
        });
        Navigator.of(context).pop();
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _saving = false;
        });
        Navigator.of(context).pop(true);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.errorGeneric)));
    } finally {
      if (mounted && _saving) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<Uint8List?> _captureReceiptImageBytes() async {
    final context = _receiptBoundaryKey.currentContext;
    if (context == null) {
      return null;
    }
    final boundary = context.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Uint8List? _trimWhiteBorders(Uint8List pngBytes) {
    final decoded = img.decodePng(pngBytes);
    if (decoded == null) {
      return null;
    }

    const whiteThreshold = 245;
    const alphaThreshold = 20;
    bool isNearWhite(img.Pixel p) {
      if (p.a < alphaThreshold) {
        return true;
      }
      return p.r >= whiteThreshold &&
          p.g >= whiteThreshold &&
          p.b >= whiteThreshold;
    }

    // Ignore single noisy pixels by requiring minimal ink count per row/column.
    const minInkPerRow = 3;
    const minInkPerColumn = 3;

    var top = -1;
    for (var y = 0; y < decoded.height; y++) {
      var ink = 0;
      for (var x = 0; x < decoded.width; x++) {
        if (!isNearWhite(decoded.getPixel(x, y))) {
          ink++;
          if (ink >= minInkPerRow) {
            top = y;
            break;
          }
        }
      }
      if (top != -1) {
        break;
      }
    }

    var bottom = -1;
    for (var y = decoded.height - 1; y >= 0; y--) {
      var ink = 0;
      for (var x = 0; x < decoded.width; x++) {
        if (!isNearWhite(decoded.getPixel(x, y))) {
          ink++;
          if (ink >= minInkPerRow) {
            bottom = y;
            break;
          }
        }
      }
      if (bottom != -1) {
        break;
      }
    }

    var left = -1;
    for (var x = 0; x < decoded.width; x++) {
      var ink = 0;
      for (var y = 0; y < decoded.height; y++) {
        if (!isNearWhite(decoded.getPixel(x, y))) {
          ink++;
          if (ink >= minInkPerColumn) {
            left = x;
            break;
          }
        }
      }
      if (left != -1) {
        break;
      }
    }

    var right = -1;
    for (var x = decoded.width - 1; x >= 0; x--) {
      var ink = 0;
      for (var y = 0; y < decoded.height; y++) {
        if (!isNearWhite(decoded.getPixel(x, y))) {
          ink++;
          if (ink >= minInkPerColumn) {
            right = x;
            break;
          }
        }
      }
      if (right != -1) {
        break;
      }
    }

    if (left == -1 || right == -1 || top == -1 || bottom == -1) {
      return null;
    }

    const border = 6;
    final cropX = (left - border).clamp(0, decoded.width - 1);
    final cropY = (top - border).clamp(0, decoded.height - 1);
    final cropRight = (right + border).clamp(0, decoded.width - 1);
    final cropBottom = (bottom + border).clamp(0, decoded.height - 1);
    final cropWidth = cropRight - cropX + 1;
    final cropHeight = cropBottom - cropY + 1;

    final cropped = img.copyCrop(
      decoded,
      x: cropX,
      y: cropY,
      width: cropWidth,
      height: cropHeight,
    );
    return Uint8List.fromList(img.encodePng(cropped));
  }

  @override
  Widget build(BuildContext context) {
    final voucher = widget.voucher;

    return PopScope(
      canPop: !_saving,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text(AppStrings.previewTitle),
              automaticallyImplyLeading: !_saving,
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.pagePadding,
                AppDimens.pagePadding,
                120,
              ),
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: RepaintBoundary(
                    key: _receiptBoundaryKey,
                    child: SizedBox(
                      width: _receiptPreviewWidth,
                      child: ColoredBox(
                        color: AppColors.white,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                                horizontal: AppDimens.spacing12,
                              ).copyWith(
                                top: AppDimens.spacing10,
                                bottom: AppDimens.spacing40,
                              ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  AppStrings.receiptShopTitle,
                                  style: AppTextStyles.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: AppDimens.spacing4),
                              const Center(
                                child: Text(
                                  AppStrings.receiptPhones,
                                  style: AppTextStyles.titleMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: AppDimens.spacing8),
                              const Divider(
                                height: 1,
                                color: AppColors.divider,
                              ),
                              _ReceiptRow(
                                label: AppStrings.receiptDateTimeLabel,
                                value: _formatDateTime(voucher.dateAndTime),
                              ),
                              _ReceiptRow(
                                label: AppStrings.nameLabel,
                                value: voucher.name,
                              ),
                              _ReceiptRow(
                                label: AppStrings.phoneLabel,
                                value: voucher.phone,
                              ),
                              _ReceiptRow(
                                label: AppStrings.addressLabel,
                                value: voucher.address,
                              ),
                              _ReceiptRow(
                                label: AppStrings.facebookLabel,
                                value: voucher.facebookAccount ?? '-',
                              ),
                              _ReceiptRow(
                                label: AppStrings.parcelNumberLabel,
                                value: voucher.parcelNumber,
                              ),
                              _ReceiptRow(
                                label: AppStrings.paymentStatusLabel,
                                value: _paymentStatusText(
                                  voucher.paymentStatus,
                                ),
                              ),
                              _ReceiptRow(
                                label: AppStrings.noteLabel,
                                value: voucher.note ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (voucher.itemImagePath != null &&
                    voucher.itemImagePath!.isNotEmpty) ...[
                  const SizedBox(height: AppDimens.spacing16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radius12),
                    child: Image.file(
                      File(voucher.itemImagePath!),
                      height: 320,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ],
            ),
            bottomNavigationBar: SafeArea(
              minimum: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.spacing12,
                AppDimens.pagePadding,
                AppDimens.spacing32,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _confirmAndSave,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radius12),
                    ),
                  ),
                  child: Text(
                    _saving
                        ? AppStrings.loading
                        : (widget.saveBeforePrint
                              ? AppStrings.printAndSave
                              : AppStrings.reprint),
                  ),
                ),
              ),
            ),
          ),
          if (_saving) ...[
            const ModalBarrier(dismissible: false, color: Color(0x66000000)),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

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
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacing8),
          Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
