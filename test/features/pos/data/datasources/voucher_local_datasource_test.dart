import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/core/db/app_database.dart' as db;
import 'package:ssa/features/pos/data/datasources/voucher_local_datasource.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';

Voucher _voucher({
  required String id,
  required String name,
  required String phone,
  required String parcel,
}) {
  final now = DateTime(2026, 3, 8, 11, 0);
  return Voucher(
    id: id,
    createdAt: now,
    updatedAt: now,
    dateAndTime: now.toIso8601String(),
    paymentStatus: 'payment_due',
    name: name,
    phone: phone,
    address: 'A',
    facebookAccount: null,
    parcelNumber: parcel,
    note: null,
    itemImagePath: null,
    dispatchReceiptImagePath: null,
    dispatchReceiptSavedAt: null,
  );
}

void main() {
  test('search matches contains on name, phone and parcel number', () async {
    final database = db.AppDatabase.forTesting(NativeDatabase.memory());
    final ds = VoucherLocalDataSource(database);
    addTearDown(database.close);

    await ds.create(
      _voucher(
        id: '1',
        name: 'ABCDEFG',
        phone: '091234567',
        parcel: 'PARCEL-777',
      ),
    );
    await ds.create(
      _voucher(
        id: '2',
        name: 'ZZZ',
        phone: '099999999',
        parcel: 'OTHER',
      ),
    );

    final byName = await ds.search('cde');
    final byPhone = await ds.search('1234');
    final byParcel = await ds.search('cel-7');

    expect(byName.map((e) => e.id), contains('1'));
    expect(byPhone.map((e) => e.id), contains('1'));
    expect(byParcel.map((e) => e.id), contains('1'));
  });

  test('preserves old and uuid-style ids through local storage', () async {
    final database = db.AppDatabase.forTesting(NativeDatabase.memory());
    final ds = VoucherLocalDataSource(database);
    addTearDown(database.close);

    const legacyId = 'v_1710000000000';
    const uuidId = '550e8400-e29b-41d4-a716-446655440000';

    await ds.create(
      _voucher(
        id: legacyId,
        name: 'Legacy',
        phone: '091111111',
        parcel: 'L-001',
      ),
    );
    await ds.create(
      _voucher(
        id: uuidId,
        name: 'Uuid',
        phone: '092222222',
        parcel: 'U-001',
      ),
    );

    final legacy = await ds.getById(legacyId);
    final uuid = await ds.getById(uuidId);

    expect(legacy?.id, legacyId);
    expect(uuid?.id, uuidId);
  });
}
