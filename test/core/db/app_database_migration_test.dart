import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/core/db/app_database.dart';

void main() {
test(
  'upgrades legacy vouchers schema to include sync and dispatch receipt metadata',
  () async {
    final executor = NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('PRAGMA user_version = 1;');
        rawDb.execute('''
          CREATE TABLE vouchers (
            id TEXT NOT NULL PRIMARY KEY,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL,
            date_and_time TEXT NOT NULL,
            name TEXT NOT NULL,
            phone TEXT NOT NULL,
            address TEXT NOT NULL,
            facebook_account TEXT NULL,
            parcel_number TEXT NOT NULL,
            note TEXT NULL,
            item_image_path TEXT NULL,
            dispatch_receipt_image_path TEXT NULL
          );
        ''');
        rawDb.execute('''
          INSERT INTO vouchers (
            id, created_at, updated_at, date_and_time, name, phone, address,
            facebook_account, parcel_number, note, item_image_path, dispatch_receipt_image_path
          ) VALUES (
            'old-1', '2026-03-08T10:00:00.000', '2026-03-08T10:00:00.000',
            '2026-03-08T10:00:00.000', 'A', '09', 'Addr', NULL, 'P-1', NULL, NULL, NULL
          );
        ''');
      },
    );
    final db = AppDatabase.forTesting(executor);
    addTearDown(db.close);

    await db.initialize();

    final columns = await db.customSelect('PRAGMA table_info(vouchers)').get();
    final columnNames = columns
        .map((r) => (r.data['name'] ?? '').toString())
        .toSet();
    expect(columnNames, contains('payment_status'));
    expect(columnNames, contains('dispatch_receipt_saved_at'));
    expect(columnNames, contains('sync_status'));
    expect(columnNames, contains('synced_at'));
    expect(columnNames, contains('created_device_id'));

    final indexes = await db.customSelect('PRAGMA index_list(vouchers)').get();
    final indexNames = indexes
        .map((r) => (r.data['name'] ?? '').toString())
        .toSet();
    expect(indexNames, contains('idx_vouchers_phone'));
    expect(indexNames, contains('idx_vouchers_parcel_number'));
    expect(indexNames, contains('idx_vouchers_created_at'));

    final countRow =
        await db.customSelect('SELECT COUNT(*) AS c FROM vouchers').getSingle();
    final count = countRow.read<int>('c');
    expect(count, 1);
  },
);
}
