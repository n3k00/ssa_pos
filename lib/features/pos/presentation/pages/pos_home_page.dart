import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/core/permissions/bluetooth_permission_service.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class PosHomePage extends ConsumerStatefulWidget {
  const PosHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<PosHomePage> createState() => _PosHomePageState();
}

class _PosHomePageState extends ConsumerState<PosHomePage> {
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeOnStartup();
    });
  }

  Future<void> _initializeOnStartup() async {
    final granted = await BluetoothPermissionService.hasRequiredPermissions();
    if (!mounted) {
      return;
    }

    setState(() {
      _permissionGranted = granted;
    });

    if (!granted) {
      return;
    }
    await _initializePrinterCoreIfNeeded();
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

  String _statusText(PrinterCore core) {
    if (core.hasConnectedPrinter && core.connectedDevice != null) {
      return '${AppStrings.printerConnectedPrefix}${core.displayName(core.connectedDevice!)}';
    }
    return core.status;
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

  @override
  Widget build(BuildContext context) {
    final printerCore = ref.watch(printerCoreProvider);
    final isPrinterConnected =
        ref.watch(printerCoreProvider.select((core) => core.hasConnectedPrinter));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: AppStrings.connectPrinter,
            icon: const Icon(Icons.bluetooth_searching),
            color: isPrinterConnected ? AppColors.success : null,
            onPressed: () async {
              final permissionResult =
                  await BluetoothPermissionService.ensureGranted();
              if (permissionResult == BluetoothPermissionResult.permanentlyDenied) {
                if (context.mounted) {
                  await _showOpenSettingsDialog();
                }
                return;
              }
              if (permissionResult != BluetoothPermissionResult.granted) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppStrings.bluetoothPermissionRequired),
                    ),
                  );
                }
                return;
              }

              setState(() {
                _permissionGranted = true;
              });

              await _initializePrinterCoreIfNeeded();

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PrinterConnectPage(core: printerCore),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimens.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spacing12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                _permissionGranted
                    ? _statusText(printerCore)
                    : AppStrings.bluetoothPermissionRequired,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            const SizedBox(height: AppDimens.spacing16),
            const Text(
              AppStrings.posReadyMessage,
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
