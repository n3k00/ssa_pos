import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/features/pos/presentation/models/dispatch_receipt_image_state.dart';

void main() {
  test('replace keeps persisted file until save success', () {
    final initial = DispatchReceiptImageState.initial('old.png');

    final update = initial.replaceWithPickedPath('new.png');

    expect(update.immediateDeletePath, isNull);
    expect(update.state.displayedPath, 'new.png');
    expect(update.state.pendingDeletionPath, 'old.png');
    expect(update.state.dirty, isTrue);
  });

  test('remove persisted image does not delete immediately', () {
    final initial = DispatchReceiptImageState.initial('old.png');

    final update = initial.removeCurrent();

    expect(update.immediateDeletePath, isNull);
    expect(update.state.displayedPath, isNull);
    expect(update.state.pendingDeletionPath, 'old.png');
    expect(update.state.dirty, isTrue);
  });

  test('remove unsaved replacement deletes temporary file immediately', () {
    final initial = DispatchReceiptImageState.initial('old.png');
    final replaced = initial.replaceWithPickedPath('new.png').state;

    final update = replaced.removeCurrent();

    expect(update.immediateDeletePath, 'new.png');
    expect(update.state.displayedPath, isNull);
    expect(update.state.pendingDeletionPath, 'old.png');
    expect(update.state.dirty, isTrue);
  });

  test('markSaved clears pending deletion and persists current path', () {
    final initial = DispatchReceiptImageState.initial('old.png');
    final replaced = initial.replaceWithPickedPath('new.png').state;

    final saved = replaced.markSaved();

    expect(saved.displayedPath, 'new.png');
    expect(saved.persistedPath, 'new.png');
    expect(saved.pendingDeletionPath, isNull);
    expect(saved.dirty, isFalse);
  });
}
