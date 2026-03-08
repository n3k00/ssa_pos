import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/core/permissions/bluetooth_permission_service.dart';
import 'package:ssa/core/printer/printer_connection_health.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_form_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';
import 'package:ssa/shared/widgets/app_drawer.dart';

class PosHomePage extends ConsumerStatefulWidget {
  const PosHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<PosHomePage> createState() => _PosHomePageState();
}

class _PosHomePageState extends ConsumerState<PosHomePage> {
  final GlobalKey<VoucherFormSectionState> _voucherFormKey =
      GlobalKey<VoucherFormSectionState>();
  Timer? _printerHealthTimer;
  bool _isSyncingPrinterHealth = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeOnStartup();
      _startPrinterHealthMonitor();
    });
  }

  @override
  void dispose() {
    _printerHealthTimer?.cancel();
    super.dispose();
  }

  Future<void> _initializeOnStartup() async {
    final granted = await BluetoothPermissionService.hasRequiredPermissions();
    if (!mounted) {
      return;
    }
    if (!granted) {
      return;
    }
    await _initializePrinterCoreIfNeeded();
    await _syncPrinterConnectionHealth();
  }

  Future<void> _initializePrinterCoreIfNeeded() async {
    final initialized = ref.read(printerCoreInitializedProvider);
    if (initialized) {
      return;
    }
    final printerCore = ref.read(printerCoreProvider);
    await printerCore.initialize();
    ref.read(printerCoreInitializedProvider.notifier).state = true;
  }

  void _startPrinterHealthMonitor() {
    _printerHealthTimer?.cancel();
    _printerHealthTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _syncPrinterConnectionHealth(),
    );
  }

  Future<void> _syncPrinterConnectionHealth() async {
    if (!mounted || _isSyncingPrinterHealth) {
      return;
    }
    final initialized = ref.read(printerCoreInitializedProvider);
    if (!initialized) {
      return;
    }
    _isSyncingPrinterHealth = true;
    try {
      final printerCore = ref.read(printerCoreProvider);
      await PrinterConnectionHealth.refresh(printerCore);
    } finally {
      _isSyncingPrinterHealth = false;
    }
  }

  Future<void> _showOpenSettingsDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.permissionSettingsTitle),
          content: const Text(AppStrings.permissionSettingsMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await openAppSettings();
              },
              child: const Text(AppStrings.openSettings),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openPrinterConnectPage() async {
    final printerCore = ref.read(printerCoreProvider);
    final permissionResult = await BluetoothPermissionService.ensureGranted();
    if (permissionResult == BluetoothPermissionResult.permanentlyDenied) {
      if (!mounted) return;
      await _showOpenSettingsDialog();
      return;
    }
    if (permissionResult != BluetoothPermissionResult.granted) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.bluetoothPermissionRequired)),
      );
      return;
    }

    await _initializePrinterCoreIfNeeded();
    await _syncPrinterConnectionHealth();

    if (!mounted) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrinterConnectPage(core: printerCore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPrinterConnected = ref.watch(
      printerCoreProvider.select((core) => core.hasConnectedPrinter),
    );

    return Scaffold(
      drawer: AppDrawer(
        activeRoute: AppRoutes.home,
        onConnectPrinterTap: _openPrinterConnectPage,
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _openPrinterConnectPage,
            icon: Icon(
              Icons.bluetooth_searching,
              color: isPrinterConnected
                  ? AppColors.success
                  : AppColors.textHint,
            ),
            tooltip: AppStrings.connectPrinter,
          ),
          const SizedBox(width: AppDimens.spacing12),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacing16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryContainer, AppColors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimens.radius16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.receipt_long, color: AppColors.primary),
                SizedBox(width: AppDimens.spacing12),
                Text(
                  AppStrings.voucherFormTitle,
                  style: AppTextStyles.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spacing12),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacing12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimens.radius16),
              border: Border.all(color: AppColors.border),
            ),
            child: VoucherFormSection(
              key: _voucherFormKey,
              showPreviewButton: false,
            ),
          ),
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
            onPressed: () => _voucherFormKey.currentState?.submitPreview(),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radius12),
              ),
            ),
            child: const Text(AppStrings.printPreview),
          ),
        ),
      ),
    );
  }
}
