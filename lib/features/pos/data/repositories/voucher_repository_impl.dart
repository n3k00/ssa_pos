import 'package:ssa/features/pos/data/datasources/voucher_local_datasource.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';

class VoucherRepositoryImpl implements VoucherRepository {
  VoucherRepositoryImpl(this._localDataSource);

  final VoucherLocalDataSource _localDataSource;

  @override
  Future<void> create(Voucher voucher) {
    return _localDataSource.create(voucher);
  }

  @override
  Future<void> update(Voucher voucher) {
    return _localDataSource.update(voucher);
  }

  @override
  Future<void> delete(String id) {
    return _localDataSource.delete(id);
  }

  @override
  Future<Voucher?> getById(String id) {
    return _localDataSource.getById(id);
  }

  @override
  Future<List<Voucher>> getPendingSync({int limit = 100}) {
    return _localDataSource.getPendingSync(limit: limit);
  }

  @override
  Future<List<Voucher>> getAll({int limit = 50, int offset = 0}) {
    return _localDataSource.getAll(limit: limit, offset: offset);
  }

  @override
  Future<List<Voucher>> search(String query, {int limit = 50, int offset = 0}) {
    return _localDataSource.search(query, limit: limit, offset: offset);
  }
}
