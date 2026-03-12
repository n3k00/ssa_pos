import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/app/design_system.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';
import 'package:ssa/features/pos/presentation/pages/voucher_list_page.dart';
import 'package:ssa/shared/providers/app_providers.dart';

class _FakeVoucherRepository implements VoucherRepository {
  _FakeVoucherRepository(this._items);

  final List<Voucher> _items;

  @override
  Future<void> create(Voucher voucher) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<Voucher>> getAll({int limit = 50, int offset = 0}) async {
    return _items.take(limit).toList(growable: false);
  }

  @override
  Future<Voucher?> getById(String id) async {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<Voucher>> search(String query, {int limit = 50, int offset = 0}) async {
    final q = query.toLowerCase();
    return _items
        .where(
          (e) =>
              e.name.toLowerCase().contains(q) ||
              e.phone.toLowerCase().contains(q) ||
              e.parcelNumber.toLowerCase().contains(q),
        )
        .take(limit)
        .toList(growable: false);
  }

  @override
  Future<void> update(Voucher voucher) async {}
}

Voucher _voucher({
  required String id,
  required String name,
  required DateTime createdAt,
}) {
  return Voucher(
    id: id,
    createdAt: createdAt,
    updatedAt: createdAt,
    dateAndTime: createdAt.toIso8601String(),
    paymentStatus: 'payment_due',
    name: name,
    phone: '09$id',
    address: 'A',
    facebookAccount: null,
    parcelNumber: 'P$id',
    note: null,
    itemImagePath: null,
    dispatchReceiptImagePath: null,
    dispatchReceiptSavedAt: null,
  );
}

void main() {
  testWidgets('filters vouchers by selected date from calendar', (tester) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 10, 0);
    final yesterday = today.subtract(const Duration(days: 1));
    final repo = _FakeVoucherRepository([
      _voucher(id: '1', name: 'Today User', createdAt: today),
      _voucher(id: '2', name: 'Yesterday User', createdAt: yesterday),
    ]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          voucherRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const VoucherListPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Today User'), findsOneWidget);
    expect(find.text('Yesterday User'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('${today.day}').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.ok));
    await tester.pumpAndSettle();

    expect(find.text('Today User'), findsOneWidget);
    expect(find.text('Yesterday User'), findsNothing);
  });
}
