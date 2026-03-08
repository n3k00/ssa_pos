import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_printer_kit/pos_printer_kit.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
import 'package:ssa/core/permissions/bluetooth_permission_service.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_print_preview_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';
import 'package:ssa/shared/widgets/app_drawer.dart';
import 'package:ssa/shared/widgets/app_state_views.dart';

class VoucherListPage extends ConsumerStatefulWidget {
  const VoucherListPage({super.key});

  @override
  ConsumerState<VoucherListPage> createState() => _VoucherListPageState();
}

class _VoucherListPageState extends ConsumerState<VoucherListPage> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Voucher>> _historyFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Voucher>> _loadHistory() {
    final repository = ref.read(voucherRepositoryProvider);
    final keyword = _query.trim();
    if (keyword.isEmpty) {
      return repository.getAll(limit: 300);
    }
    return repository.search(keyword, limit: 300);
  }

  Future<void> _refresh() async {
    final next = _loadHistory();
    setState(() {
      _historyFuture = next;
    });
    await next;
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
    if (!mounted) {
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PrinterConnectPage(core: printerCore),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _historyFuture = _loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        activeRoute: AppRoutes.voucherList,
        onConnectPrinterTap: _openPrinterConnectPage,
      ),
      appBar: AppBar(title: const Text(AppStrings.voucherListTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.pagePadding,
              AppDimens.pagePadding,
              AppDimens.pagePadding,
              AppDimens.spacing8,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radius16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x12000000),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textHint),
                  const SizedBox(width: AppDimens.spacing8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: const InputDecoration(
                        hintText: AppStrings.voucherSearchHint,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      icon: const Icon(Icons.close, size: AppDimens.icon20),
                      color: AppColors.textHint,
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Voucher>>(
              future: _historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const AppLoadingView(message: AppStrings.loading);
                }
                if (snapshot.hasError) {
                  return AppErrorView(
                    message: AppStrings.errorGeneric,
                    onRetry: _refresh,
                  );
                }

                final vouchers = snapshot.data ?? const <Voucher>[];
                if (vouchers.isEmpty) {
                  return const AppEmptyView(
                    message: 'No vouchers found.',
                    icon: Icons.receipt_long,
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimens.pagePadding,
                      0,
                      AppDimens.pagePadding,
                      AppDimens.pagePadding,
                    ),
                    itemCount: vouchers.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.divider),
                    itemBuilder: (context, index) {
                      final voucher = vouchers[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: AppDimens.spacing8,
                          horizontal: AppDimens.spacing4,
                        ),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(AppDimens.radius8),
                          ),
                          child: const Icon(
                            Icons.receipt_long_outlined,
                            color: AppColors.primary,
                            size: AppDimens.icon20,
                          ),
                        ),
                        title: Text(
                          voucher.name,
                          style: AppTextStyles.titleMedium,
                        ),
                        subtitle: Text(
                          voucher.phone,
                          style: AppTextStyles.bodyMedium,
                        ),
                        onTap: () async {
                          final printed = await Navigator.of(context)
                              .push<bool>(
                                MaterialPageRoute<bool>(
                                  builder: (_) => VoucherPrintPreviewPage(
                                    voucher: voucher,
                                    saveBeforePrint: false,
                                  ),
                                ),
                              );
                          if (!mounted) {
                            return;
                          }
                          final messenger = ScaffoldMessenger.of(this.context);
                          if (printed == true) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(AppStrings.voucherReprinted),
                              ),
                            );
                          } else if (printed == false) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(AppStrings.voucherReprintFailed),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
