import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:ssa/core/db/tables/vouchers.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Vouchers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _ensureVoucherIndexes();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(vouchers, vouchers.paymentStatus);
          }
          if (from < 3) {
            await m.addColumn(
              vouchers,
              vouchers.dispatchReceiptSavedAt,
            );
          }
          if (from < 4) {
            await m.addColumn(vouchers, vouchers.syncStatus);
            await m.addColumn(vouchers, vouchers.syncedAt);
            await m.addColumn(vouchers, vouchers.createdDeviceId);
          }
          await _ensureVoucherIndexes();
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  Future<void> initialize() async {
    await customSelect('SELECT 1').get();
  }

  Future<void> _ensureVoucherIndexes() async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vouchers_phone ON vouchers (phone)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vouchers_parcel_number ON vouchers (parcel_number)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_vouchers_created_at ON vouchers (created_at)',
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'ssa_pos.sqlite'));
    return NativeDatabase.createInBackground(dbFile);
  });
}
