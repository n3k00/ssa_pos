import 'package:ssa/features/pos/domain/entities/voucher.dart';

abstract class VoucherRepository {
  Future<void> create(Voucher voucher);
  Future<void> update(Voucher voucher);
  Future<void> delete(String id);
  Future<Voucher?> getById(String id);
  Future<List<Voucher>> getAll({int limit = 50, int offset = 0});
  Future<List<Voucher>> search(
    String query, {
    int limit = 50,
    int offset = 0,
  });
}
