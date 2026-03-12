import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/app/router/app_router.dart';
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
  DateTime? _selectedDate;

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

  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
      _historyFuture = _loadHistory();
    });
  }

  Future<void> _pickDateFilter() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 2, 12, 31),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
      _historyFuture = _loadHistory();
    });
  }

  void _clearDateFilter() {
    setState(() {
      _selectedDate = null;
      _historyFuture = _loadHistory();
    });
  }

  bool _matchesSelectedDate(Voucher voucher) {
    final selected = _selectedDate;
    if (selected == null) {
      return true;
    }
    final date = voucher.createdAt;
    return date.year == selected.year &&
        date.month == selected.month &&
        date.day == selected.day;
  }

  String _dateLabel(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(activeRoute: AppRoutes.voucherList),
      appBar: AppBar(
        title: Text(AppStrings.voucherListTitle),
        actions: [
          IconButton(
            onPressed: _pickDateFilter,
            tooltip: AppStrings.filterByDate,
            icon: Icon(
              Icons.calendar_month_outlined,
              color: _selectedDate == null
                  ? AppColors.textHint
                  : AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimens.spacing8),
        ],
      ),
      body: Column(
        children: [
          if (_selectedDate != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pagePadding,
                AppDimens.spacing8,
                AppDimens.pagePadding,
                0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ActionChip(
                  avatar: const Icon(Icons.event, size: AppDimens.icon16),
                  label: Text(_dateLabel(_selectedDate!)),
                  onPressed: _clearDateFilter,
                  tooltip: AppStrings.clearDateFilter,
                ),
              ),
            ),
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
                      decoration: InputDecoration(
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
                  return AppLoadingView(message: AppStrings.loading);
                }
                if (snapshot.hasError) {
                  return AppErrorView(
                    message: AppStrings.errorGeneric,
                    onRetry: _refresh,
                  );
                }

                final vouchers = (snapshot.data ?? const <Voucher>[])
                    .where(_matchesSelectedDate)
                    .toList(growable: false);
                if (vouchers.isEmpty) {
                  return AppEmptyView(
                    message: AppStrings.voucherEmptyMessage,
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
                              SnackBar(
                                content: Text(AppStrings.voucherReprinted),
                              ),
                            );
                          } else if (printed == false) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(AppStrings.voucherReprintFailed),
                              ),
                            );
                          }
                          await _refresh();
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
