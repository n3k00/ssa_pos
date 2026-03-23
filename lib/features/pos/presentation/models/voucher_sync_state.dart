class VoucherSyncState {
  const VoucherSyncState({
    this.isSyncing = false,
    this.lastSyncedAt,
    this.hasFailure = false,
    this.errorMessage,
  });

  final bool isSyncing;
  final DateTime? lastSyncedAt;
  final bool hasFailure;
  final String? errorMessage;

  VoucherSyncState copyWith({
    bool? isSyncing,
    Object? lastSyncedAt = _unset,
    bool? hasFailure,
    Object? errorMessage = _unset,
  }) {
    return VoucherSyncState(
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncedAt: identical(lastSyncedAt, _unset)
          ? this.lastSyncedAt
          : lastSyncedAt as DateTime?,
      hasFailure: hasFailure ?? this.hasFailure,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _unset = Object();
}
