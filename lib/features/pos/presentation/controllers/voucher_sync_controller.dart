import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ssa/core/sync/voucher_sync_status_service.dart';
import 'package:ssa/features/pos/presentation/models/voucher_sync_state.dart';

class VoucherSyncController extends StateNotifier<VoucherSyncState> {
  VoucherSyncController(this._statusService) : super(const VoucherSyncState());

  final VoucherSyncStatusService _statusService;

  Future<void> loadSavedState() async {
    final iso = await _statusService.loadLastSyncedAtIso();
    if (iso == null || iso.isEmpty) {
      return;
    }
    final parsed = DateTime.tryParse(iso);
    if (parsed == null) {
      return;
    }
    state = state.copyWith(lastSyncedAt: parsed);
  }

  void markSyncing() {
    state = state.copyWith(
      isSyncing: true,
      hasFailure: false,
      errorMessage: null,
    );
  }

  Future<void> markSuccess(DateTime syncedAt) async {
    await _statusService.saveLastSyncedAtIso(syncedAt.toIso8601String());
    state = state.copyWith(
      isSyncing: false,
      hasFailure: false,
      lastSyncedAt: syncedAt,
      errorMessage: null,
    );
  }

  void markFailure(String? reason) {
    state = state.copyWith(
      isSyncing: false,
      hasFailure: true,
      errorMessage: reason,
    );
  }
}
