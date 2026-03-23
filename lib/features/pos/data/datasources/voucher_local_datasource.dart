import 'package:drift/drift.dart';
import 'package:ssa/core/db/app_database.dart' as db;
import 'package:ssa/features/pos/domain/entities/voucher.dart';

class VoucherLocalDataSource {
  VoucherLocalDataSource(this._database);

  final db.AppDatabase _database;

  Future<void> create(Voucher voucher) async {
    await _database.into(_database.vouchers).insert(_toCompanion(voucher));
  }

  Future<void> update(Voucher voucher) async {
    await (_database.update(
      _database.vouchers,
    )..where((table) => table.id.equals(voucher.id))).write(_toCompanion(voucher));
  }

  Future<void> delete(String id) async {
    await (_database.delete(_database.vouchers)
      ..where((table) => table.id.equals(id))).go();
  }

  Future<Voucher?> getById(String id) async {
    final row = await (_database.select(
      _database.vouchers,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return null;
    }
    return _toDomain(row);
  }

  Future<List<Voucher>> getPendingSync({int limit = 100}) async {
    final query = _database.select(_database.vouchers)
      ..where((table) => table.syncStatus.equals('pending'))
      ..orderBy([(table) => OrderingTerm.asc(table.createdAt)])
      ..limit(limit);

    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  Future<List<Voucher>> getAll({int limit = 50, int offset = 0}) async {
    final query = _database.select(_database.vouchers)
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  Future<List<Voucher>> search(
    String keyword, {
    int limit = 50,
    int offset = 0,
  }) async {
    final sanitizedKeyword = keyword.trim();
    if (sanitizedKeyword.isEmpty) {
      return getAll(limit: limit, offset: offset);
    }

    final pattern = '%${sanitizedKeyword.toLowerCase()}%';
    final query = _database.select(_database.vouchers)
      ..where(
        (table) =>
            table.name.lower().like(pattern) |
            table.phone.lower().like(pattern) |
            table.parcelNumber.lower().like(pattern),
      )
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)])
      ..limit(limit, offset: offset);

    final rows = await query.get();
    return rows.map(_toDomain).toList(growable: false);
  }

  db.VouchersCompanion _toCompanion(Voucher voucher) {
    return db.VouchersCompanion(
      id: Value(voucher.id),
      createdAt: Value(voucher.createdAt.toIso8601String()),
      updatedAt: Value(voucher.updatedAt.toIso8601String()),
      dateAndTime: Value(voucher.dateAndTime),
      paymentStatus: Value(voucher.paymentStatus),
      name: Value(voucher.name),
      phone: Value(voucher.phone),
      address: Value(voucher.address),
      facebookAccount: Value(voucher.facebookAccount),
      parcelNumber: Value(voucher.parcelNumber),
      note: Value(voucher.note),
      itemImagePath: Value(voucher.itemImagePath),
      dispatchReceiptImagePath: Value(voucher.dispatchReceiptImagePath),
      dispatchReceiptSavedAt: Value(voucher.dispatchReceiptSavedAt),
      syncStatus: Value(voucher.syncStatus),
      syncedAt: Value(voucher.syncedAt),
      createdDeviceId: Value(voucher.createdDeviceId),
    );
  }

  Voucher _toDomain(db.Voucher row) {
    return Voucher(
      id: row.id,
      createdAt: DateTime.parse(row.createdAt),
      updatedAt: DateTime.parse(row.updatedAt),
      dateAndTime: row.dateAndTime,
      paymentStatus: row.paymentStatus,
      name: row.name,
      phone: row.phone,
      address: row.address,
      facebookAccount: row.facebookAccount,
      parcelNumber: row.parcelNumber,
      note: row.note,
      itemImagePath: row.itemImagePath,
      dispatchReceiptImagePath: row.dispatchReceiptImagePath,
      dispatchReceiptSavedAt: row.dispatchReceiptSavedAt,
      syncStatus: row.syncStatus,
      syncedAt: row.syncedAt,
      createdDeviceId: row.createdDeviceId,
    );
  }
}
