import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/core/device/device_id_service.dart';
import 'package:ssa/core/logging/app_logger.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_cloud_repository.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';
import 'package:ssa/features/pos/domain/services/voucher_sync_service.dart';

void main() {
  test('uploads pending vouchers and marks them synced', () async {
    final pendingVoucher = _voucher(id: 'local-1', syncStatus: 'pending');
    final localRepository = _FakeVoucherRepository(
      vouchers: [pendingVoucher],
    );
    final cloudRepository = _FakeVoucherCloudRepository();
    final service = VoucherSyncService(
      voucherRepository: localRepository,
      voucherCloudRepository: cloudRepository,
      deviceIdService: _FakeDeviceIdService(),
      currentUserId: () => 'user-1',
      logger: _FakeLogger(),
      onSyncStarted: () {},
      onSyncSucceeded: (_) async {},
      onSyncFailed: (_) {},
    );

    await service.syncIfAuthenticated();

    expect(cloudRepository.upserted.single.id, pendingVoucher.id);
    final updated = await localRepository.getById(pendingVoucher.id);
    expect(updated?.syncStatus, 'synced');
    expect(updated?.createdDeviceId, 'device-1');
    expect(updated?.syncedAt, isNotNull);
  });

  test('downloads missing cloud vouchers into local storage', () async {
    final cloudVoucher = _voucher(id: 'cloud-1', syncStatus: 'synced');
    final localRepository = _FakeVoucherRepository();
    final cloudRepository = _FakeVoucherCloudRepository(
      fetched: [cloudVoucher],
    );
    final service = VoucherSyncService(
      voucherRepository: localRepository,
      voucherCloudRepository: cloudRepository,
      deviceIdService: _FakeDeviceIdService(),
      currentUserId: () => 'user-1',
      logger: _FakeLogger(),
      onSyncStarted: () {},
      onSyncSucceeded: (_) async {},
      onSyncFailed: (_) {},
    );

    await service.syncIfAuthenticated();

    final stored = await localRepository.getById(cloudVoucher.id);
    expect(stored, isNotNull);
    expect(stored?.syncStatus, 'synced');
  });
}

Voucher _voucher({required String id, required String syncStatus}) {
  final now = DateTime.utc(2026, 3, 23, 12, 0);
  return Voucher(
    id: id,
    createdAt: now,
    updatedAt: now,
    dateAndTime: now.toIso8601String(),
    paymentStatus: 'Paid',
    name: 'Mg Mg',
    phone: '09123456789',
    address: 'Yangon',
    parcelNumber: 'P-001',
    syncStatus: syncStatus,
  );
}

class _FakeVoucherRepository implements VoucherRepository {
  _FakeVoucherRepository({List<Voucher>? vouchers}) {
    if (vouchers != null) {
      for (final voucher in vouchers) {
        _vouchers[voucher.id] = voucher;
      }
    }
  }

  final Map<String, Voucher> _vouchers = <String, Voucher>{};

  @override
  Future<void> create(Voucher voucher) async {
    _vouchers[voucher.id] = voucher;
  }

  @override
  Future<void> delete(String id) async {
    _vouchers.remove(id);
  }

  @override
  Future<List<Voucher>> getAll({int limit = 50, int offset = 0}) async {
    return _vouchers.values.toList(growable: false);
  }

  @override
  Future<Voucher?> getById(String id) async {
    return _vouchers[id];
  }

  @override
  Future<List<Voucher>> getPendingSync({int limit = 100}) async {
    return _vouchers.values
        .where((voucher) => voucher.syncStatus == 'pending')
        .take(limit)
        .toList(growable: false);
  }

  @override
  Future<List<Voucher>> search(
    String query, {
    int limit = 50,
    int offset = 0,
  }) async {
    return _vouchers.values.toList(growable: false);
  }

  @override
  Future<void> update(Voucher voucher) async {
    _vouchers[voucher.id] = voucher;
  }
}

class _FakeVoucherCloudRepository implements VoucherCloudRepository {
  _FakeVoucherCloudRepository({List<Voucher>? fetched})
    : _fetched = fetched ?? <Voucher>[];

  final List<Voucher> _fetched;
  final List<Voucher> upserted = <Voucher>[];

  @override
  Future<List<Voucher>> fetchAll() async {
    return _fetched;
  }

  @override
  Future<void> upsert(Voucher voucher, {required String deviceId}) async {
    upserted.add(voucher);
  }
}

class _FakeDeviceIdService extends DeviceIdService {
  @override
  Future<String> getOrCreateDeviceId() async => 'device-1';
}

class _FakeLogger implements AppLogger {
  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {}

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {}
}
