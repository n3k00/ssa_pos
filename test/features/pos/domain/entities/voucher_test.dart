import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';

void main() {
  final voucher = Voucher(
    id: 'v1',
    createdAt: DateTime(2026, 3, 12, 10),
    updatedAt: DateTime(2026, 3, 12, 10),
    dateAndTime: '2026-03-12T10:00:00.000',
    paymentStatus: 'payment_due',
    name: 'Aye',
    phone: '09123',
    address: 'Yangon',
    facebookAccount: 'fb-user',
    parcelNumber: 'P-1',
    note: 'fragile',
    itemImagePath: '/item.jpg',
    dispatchReceiptImagePath: '/dispatch.jpg',
    dispatchReceiptSavedAt: '2026-03-12T10:10:00.000',
  );

  test('copyWith keeps nullable fields when not provided', () {
    final updated = voucher.copyWith(name: 'Su');

    expect(updated.name, 'Su');
    expect(updated.facebookAccount, voucher.facebookAccount);
    expect(updated.note, voucher.note);
    expect(updated.itemImagePath, voucher.itemImagePath);
    expect(updated.dispatchReceiptImagePath, voucher.dispatchReceiptImagePath);
    expect(updated.dispatchReceiptSavedAt, voucher.dispatchReceiptSavedAt);
  });

  test('copyWith can explicitly clear nullable fields', () {
    final updated = voucher.copyWith(
      facebookAccount: null,
      note: null,
      itemImagePath: null,
      dispatchReceiptImagePath: null,
      dispatchReceiptSavedAt: null,
    );

    expect(updated.facebookAccount, isNull);
    expect(updated.note, isNull);
    expect(updated.itemImagePath, isNull);
    expect(updated.dispatchReceiptImagePath, isNull);
    expect(updated.dispatchReceiptSavedAt, isNull);
  });
}
