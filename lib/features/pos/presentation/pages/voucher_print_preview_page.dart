import 'dart:async';
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
import 'package:ssa/core/settings/receipt_settings_service.dart';
import 'package:ssa/features/pos/data/datasources/voucher_image_local_datasource.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/presentation/models/dispatch_receipt_image_state.dart';
import 'package:ssa/features/pos/presentation/widgets/receipt_attachment_card.dart';
import 'package:ssa/features/pos/presentation/widgets/receipt_preview_card.dart';
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
  bool _dispatchSaving = false;
  late DispatchReceiptImageState _dispatchImageState;
  bool _dispatchDirty = false;
  late Voucher _voucher;
  String _receiptTitle = AppStrings.receiptShopTitle;
  String _receiptPhones = AppStrings.receiptPhones;
  double _receiptTitleFontSize = 22;
  double _receiptPhonesFontSize = 16;
  double _receiptRowFontSize = 14;
  double _receiptPaddingTop = 10;
  double _receiptPaddingHorizontal = 12;
  double _receiptPaddingBottom = 40;
  PrintDensityPreset _printDensityPreset = PrintDensityPreset.balanced;
  int _feedLinesAfterPrint = 0;

  @override
  void initState() {
    super.initState();
    _voucher = widget.voucher;
    _dispatchImageState = DispatchReceiptImageState.initial(
      _voucher.dispatchReceiptImagePath,
    );
    _loadReceiptSettings();
    if (!widget.saveBeforePrint) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _reloadLatestVoucher();
      });
    }
  }

  Future<void> _loadReceiptSettings() async {
    final service = ref.read(receiptSettingsServiceProvider);
    final settings = await service.load(
      defaultTitle: AppStrings.receiptShopTitle,
      defaultPhones: AppStrings.receiptPhones,
      defaultTitleFontSize: 22,
      defaultPhonesFontSize: 16,
      defaultRowFontSize: 14,
      defaultPaddingTop: 10,
      defaultPaddingHorizontal: 12,
      defaultPaddingBottom: 40,
      defaultPrintDensityPreset: PrintDensityPreset.balanced,
      defaultFeedLinesAfterPrint: 0,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _receiptTitle = settings.title;
      _receiptPhones = settings.phones;
      _receiptTitleFontSize = settings.titleFontSize;
      _receiptPhonesFontSize = settings.phonesFontSize;
      _receiptRowFontSize = settings.rowFontSize;
      _receiptPaddingTop = settings.paddingTop;
      _receiptPaddingHorizontal = settings.paddingHorizontal;
      _receiptPaddingBottom = settings.paddingBottom;
      _printDensityPreset = settings.printDensityPreset;
      _feedLinesAfterPrint = settings.feedLinesAfterPrint;
    });
  }

  int _thresholdForPreset(PrintDensityPreset preset) {
    switch (preset) {
      case PrintDensityPreset.light:
        return 196;
      case PrintDensityPreset.balanced:
        return 180;
      case PrintDensityPreset.dark:
        return 164;
    }
  }

  Future<void> _reloadLatestVoucher() async {
    final latest = await ref.read(voucherRepositoryProvider).getById(_voucher.id);
    if (!mounted || latest == null) {
      return;
    }
    setState(() {
      _voucher = latest;
      _dispatchImageState = _dispatchImageState.syncedFromPersistence(
        latest.dispatchReceiptImagePath,
      );
      _dispatchDirty = false;
    });
  }

  Future<void> _showFullImage(String imagePath) async {
    final imageFile = File(imagePath);
    if (!imageFile.existsSync()) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.errorGeneric)),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(AppDimens.pagePadding),
          child: Stack(
            children: [
              InteractiveViewer(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radius12),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return ColoredBox(
                        color: AppColors.surface,
                        child: SizedBox(
                          width: double.infinity,
                          height: 280,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: AppDimens.icon28,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: AppDimens.spacing8,
                right: AppDimens.spacing8,
                child: IconButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickDispatchReceiptImage(VoucherImageSource source) async {
    final dataSource = ref.read(voucherImageLocalDataSourceProvider);
    final pickedPath = await dataSource.pickAndSave(
      source: source,
      type: VoucherImageType.dispatchReceipt,
    );
    if (pickedPath == null || !mounted) {
      return;
    }
    final update = _dispatchImageState.replaceWithPickedPath(pickedPath);
    if (update.immediateDeletePath != null) {
      await dataSource.deleteSavedImage(update.immediateDeletePath);
    }
    setState(() {
      _dispatchImageState = update.state;
      _dispatchDirty = true;
    });
  }

  Future<void> _showDispatchSourceSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: Text(AppStrings.camera),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _pickDispatchReceiptImage(VoucherImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(AppStrings.gallery),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _pickDispatchReceiptImage(VoucherImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeDispatchReceiptImage() async {
    if (_dispatchImageState.displayedPath == null) {
      return;
    }
    final update = _dispatchImageState.removeCurrent();
    if (update.immediateDeletePath != null) {
      await ref
          .read(voucherImageLocalDataSourceProvider)
          .deleteSavedImage(update.immediateDeletePath);
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _dispatchImageState = update.state;
      _dispatchDirty = true;
    });
  }

  Future<void> _saveDispatchReceiptImage() async {
    if (_dispatchSaving) {
      return;
    }
    setState(() {
      _dispatchSaving = true;
    });
    try {
      final repository = ref.read(voucherRepositoryProvider);
      final imageDataSource = ref.read(voucherImageLocalDataSourceProvider);
      final logger = ref.read(appLoggerProvider);
      final updated = Voucher(
        id: _voucher.id,
        createdAt: _voucher.createdAt,
        updatedAt: DateTime.now(),
        dateAndTime: _voucher.dateAndTime,
        paymentStatus: _voucher.paymentStatus,
        name: _voucher.name,
        phone: _voucher.phone,
        address: _voucher.address,
        facebookAccount: _voucher.facebookAccount,
        parcelNumber: _voucher.parcelNumber,
        note: _voucher.note,
        itemImagePath: _voucher.itemImagePath,
        dispatchReceiptImagePath: _dispatchImageState.displayedPath,
        dispatchReceiptSavedAt: _dispatchImageState.displayedPath == null
            ? null
            : DateTime.now().toIso8601String(),
        syncStatus: 'pending',
        syncedAt: null,
        createdDeviceId: _voucher.createdDeviceId,
      );
      await repository.update(updated);
      final pendingDeletePath = _dispatchImageState.pendingDeletionPath;
      if (!mounted) {
        return;
      }
      setState(() {
        _voucher = updated;
        _dispatchImageState = _dispatchImageState.markSaved();
        _dispatchDirty = false;
      });
      if (pendingDeletePath != null &&
          pendingDeletePath != updated.dispatchReceiptImagePath) {
        try {
          await imageDataSource.deleteSavedImage(pendingDeletePath);
        } catch (error, stackTrace) {
          logger.error(
            'Failed to clean up old dispatch receipt image after save.',
            error: error,
            stackTrace: stackTrace,
          );
        }
      }
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.dispatchReceiptSaved)));
      unawaited(ref.read(voucherSyncServiceProvider).syncIfAuthenticated());
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.dispatchReceiptSaveFailed)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _dispatchSaving = false;
        });
      }
    }
  }

  String _paymentStatusText(String code) {
    if (code == 'payment_paid') {
      return AppStrings.paymentStatusPaid;
    }
    if (code == 'payment_due') {
      return AppStrings.paymentStatusDue;
    }
    return code;
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

  String? _dispatchReceiptAddedLabel(String? iso) {
    if (iso == null || iso.isEmpty) {
      return null;
    }
    return '${AppStrings.dispatchReceiptAddedOnPrefix}${_formatDateTime(iso)}';
  }

  String? _persistedDispatchReceiptAddedLabel() {
    if (_dispatchDirty) {
      return null;
    }
    if (_dispatchImageState.displayedPath == null) {
      return null;
    }
    if (_dispatchImageState.displayedPath != _voucher.dispatchReceiptImagePath) {
      return null;
    }
    return _dispatchReceiptAddedLabel(_voucher.dispatchReceiptSavedAt);
  }

  Widget _buildAttachmentsSection(Voucher voucher) {
    final hasItemImage =
        voucher.itemImagePath != null && voucher.itemImagePath!.isNotEmpty;
    final showSection = hasItemImage || !widget.saveBeforePrint;
    if (!showSection) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: _receiptPreviewWidth,
        padding: const EdgeInsets.all(AppDimens.spacing12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radius16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.attachmentsLabel,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.spacing12),
            if (hasItemImage)
              ReceiptAttachmentCard(
                title: AppStrings.itemImageLabel,
                subtitle: AppStrings.tapImageToView,
                imagePath: voucher.itemImagePath!,
                width: _receiptPreviewWidth - (AppDimens.spacing12 * 2),
                height: 216,
                onTap: () => _showFullImage(voucher.itemImagePath!),
              ),
            if (hasItemImage && !widget.saveBeforePrint)
              const SizedBox(height: AppDimens.spacing12),
            if (!widget.saveBeforePrint) _buildDispatchAttachmentCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDispatchAttachmentCard() {
    final displayedPath = _dispatchImageState.displayedPath;
    final imageWidth = _receiptPreviewWidth - (AppDimens.spacing12 * 2);
    final subtitle = _dispatchDirty
        ? AppStrings.changesNotSaved
        : _persistedDispatchReceiptAddedLabel() ?? AppStrings.tapImageToView;

    return ReceiptAttachmentCard(
      title: AppStrings.dispatchReceiptImageLabel,
      subtitle: subtitle,
      imagePath: displayedPath,
      width: imageWidth,
      height: 216,
      onTap: displayedPath == null ? null : () => _showFullImage(displayedPath),
      primaryAction: displayedPath == null
          ? AttachmentAction(
              icon: Icons.add_a_photo_outlined,
              onTap: _showDispatchSourceSheet,
            )
          : AttachmentAction(
              icon: Icons.edit_outlined,
              onTap: _showDispatchSourceSheet,
            ),
      secondaryAction: displayedPath == null
          ? null
          : AttachmentAction(
              icon: Icons.delete_outline,
              onTap: _removeDispatchReceiptImage,
            ),
      footer: _dispatchDirty
          ? SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _dispatchSaving ? null : _saveDispatchReceiptImage,
                icon: const Icon(Icons.save_outlined),
                label: Text(
                  _dispatchSaving
                      ? AppStrings.loading
                      : AppStrings.saveDispatchReceiptImage,
                ),
              ),
            )
          : null,
      emptyStateLabel: AppStrings.addDispatchReceiptImage,
    );
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
          SnackBar(content: Text(AppStrings.printerNotConnected)),
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
        config: PrinterPrintConfig(
          width: 576,
          ditherMode: PrinterDitherMode.threshold,
          threshold: _thresholdForPreset(_printDensityPreset),
          chunkDelayMs: 6,
          maxChunkSize: 220,
          feedLinesAfterPrint: _feedLinesAfterPrint,
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
        await printerCore.disconnect();
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppStrings.voucherPrintFailedNotSaved)),
        );
        return;
      }

      final repository = ref.read(voucherRepositoryProvider);
      await repository.create(_voucher);
      unawaited(ref.read(voucherSyncServiceProvider).syncIfAuthenticated());
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.voucherSavedAndPrinted)),
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
      ).showSnackBar(SnackBar(content: Text(AppStrings.errorGeneric)));
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
    final voucher = _voucher;

    return PopScope(
      canPop: !_saving,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(AppStrings.previewTitle),
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
                        child: ReceiptPreviewCard(
                          width: _receiptPreviewWidth,
                          title: _receiptTitle,
                          phones: _receiptPhones,
                          titleFontSize: _receiptTitleFontSize,
                          phonesFontSize: _receiptPhonesFontSize,
                          rowFontSize: _receiptRowFontSize,
                          paddingTop: _receiptPaddingTop,
                          paddingHorizontal: _receiptPaddingHorizontal,
                          paddingBottom: _receiptPaddingBottom,
                          rows: [
                            ReceiptPreviewRowData(
                              label: AppStrings.receiptDateTimeLabel,
                              value: _formatDateTime(voucher.dateAndTime),
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.nameLabel,
                              value: voucher.name,
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.phoneLabel,
                              value: voucher.phone,
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.addressLabel,
                              value: voucher.address,
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.facebookLabel,
                              value: voucher.facebookAccount ?? '-',
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.parcelNumberLabel,
                              value: voucher.parcelNumber,
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.paymentStatusLabel,
                              value: _paymentStatusText(voucher.paymentStatus),
                            ),
                            ReceiptPreviewRowData(
                              label: AppStrings.noteLabel,
                              value: voucher.note ?? '-',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.spacing16),
                _buildAttachmentsSection(voucher),
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
