class DispatchReceiptImageUpdateResult {
  const DispatchReceiptImageUpdateResult({
    required this.state,
    this.immediateDeletePath,
  });

  final DispatchReceiptImageState state;
  final String? immediateDeletePath;
}

class DispatchReceiptImageState {
  const DispatchReceiptImageState({
    required this.displayedPath,
    required this.persistedPath,
    required this.pendingDeletionPath,
    required this.dirty,
  });

  factory DispatchReceiptImageState.initial(String? path) {
    return DispatchReceiptImageState(
      displayedPath: path,
      persistedPath: path,
      pendingDeletionPath: null,
      dirty: false,
    );
  }

  final String? displayedPath;
  final String? persistedPath;
  final String? pendingDeletionPath;
  final bool dirty;

  DispatchReceiptImageState syncedFromPersistence(String? path) {
    return DispatchReceiptImageState.initial(path);
  }

  DispatchReceiptImageUpdateResult replaceWithPickedPath(String pickedPath) {
    final shouldDeleteCurrentImmediately =
        displayedPath != null &&
        displayedPath != pickedPath &&
        displayedPath != persistedPath;

    return DispatchReceiptImageUpdateResult(
      immediateDeletePath: shouldDeleteCurrentImmediately ? displayedPath : null,
      state: DispatchReceiptImageState(
        displayedPath: pickedPath,
        persistedPath: persistedPath,
        pendingDeletionPath:
            persistedPath != null && persistedPath != pickedPath
                ? persistedPath
                : pendingDeletionPath,
        dirty: true,
      ),
    );
  }

  DispatchReceiptImageUpdateResult removeCurrent() {
    final shouldDeleteCurrentImmediately =
        displayedPath != null && displayedPath != persistedPath;

    return DispatchReceiptImageUpdateResult(
      immediateDeletePath: shouldDeleteCurrentImmediately ? displayedPath : null,
      state: DispatchReceiptImageState(
        displayedPath: null,
        persistedPath: persistedPath,
        pendingDeletionPath:
            shouldDeleteCurrentImmediately ? pendingDeletionPath : displayedPath,
        dirty: true,
      ),
    );
  }

  DispatchReceiptImageState markSaved() {
    return DispatchReceiptImageState(
      displayedPath: displayedPath,
      persistedPath: displayedPath,
      pendingDeletionPath: null,
      dirty: false,
    );
  }
}
