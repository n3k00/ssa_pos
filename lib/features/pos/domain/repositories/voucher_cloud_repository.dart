import 'package:ssa/features/pos/domain/entities/voucher.dart';

abstract class VoucherCloudRepository {
  Future<void> upsert(Voucher voucher, {required String deviceId});
  Future<List<Voucher>> fetchAll();
}
