import 'package:ssa/core/device/device_id_service.dart';
import 'package:ssa/core/logging/app_logger.dart';
import 'package:ssa/features/pos/domain/entities/voucher.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_cloud_repository.dart';
import 'package:ssa/features/pos/domain/repositories/voucher_repository.dart';

class VoucherSyncService {
  VoucherSyncService({
    required VoucherRepository voucherRepository,
    required VoucherCloudRepository voucherCloudRepository,
    required DeviceIdService deviceIdService,
    required String? Function() currentUserId,
    required AppLogger logger,
    required void Function() onSyncStarted,
    required Future<void> Function(DateTime syncedAt) onSyncSucceeded,
    required void Function(String? reason) onSyncFailed,
  }) : _voucherRepository = voucherRepository,
       _voucherCloudRepository = voucherCloudRepository,
       _deviceIdService = deviceIdService,
       _currentUserId = currentUserId,
       _logger = logger,
       _onSyncStarted = onSyncStarted,
       _onSyncSucceeded = onSyncSucceeded,
       _onSyncFailed = onSyncFailed;

  final VoucherRepository _voucherRepository;
  final VoucherCloudRepository _voucherCloudRepository;
  final DeviceIdService _deviceIdService;
  final String? Function() _currentUserId;
  final AppLogger _logger;
  final void Function() _onSyncStarted;
  final Future<void> Function(DateTime syncedAt) _onSyncSucceeded;
  final void Function(String? reason) _onSyncFailed;

  bool _isSyncing = false;

  Future<void> syncIfAuthenticated() async {
    if (_isSyncing || _currentUserId() == null) {
      return;
    }

    _isSyncing = true;
    _onSyncStarted();
    try {
      final deviceId = await _deviceIdService.getOrCreateDeviceId();
      await _pushPendingVouchers(deviceId);
      await _pullCloudVouchers();
      await _onSyncSucceeded(DateTime.now());
    } catch (error, stackTrace) {
      _logger.error(
        'Voucher sync failed.',
        error: error,
        stackTrace: stackTrace,
      );
      _onSyncFailed(_userFriendlyError(error));
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _pushPendingVouchers(String deviceId) async {
    final pendingVouchers = await _voucherRepository.getPendingSync(limit: 200);

    for (final voucher in pendingVouchers) {
      try {
        final syncedAt = DateTime.now().toUtc().toIso8601String();
        final createdDeviceId = voucher.createdDeviceId ?? deviceId;

        await _voucherCloudRepository.upsert(voucher, deviceId: deviceId);
        await _voucherRepository.update(
          voucher.copyWith(
            syncStatus: 'synced',
            syncedAt: syncedAt,
            createdDeviceId: createdDeviceId,
          ),
        );
      } catch (error, stackTrace) {
        _logger.error(
          'Failed to upload voucher ${voucher.id} to Firestore.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _pullCloudVouchers() async {
    final cloudVouchers = await _voucherCloudRepository.fetchAll();

    for (final cloudVoucher in cloudVouchers) {
      final existing = await _voucherRepository.getById(cloudVoucher.id);
      if (existing != null) {
        continue;
      }

      try {
        await _voucherRepository.create(
          _markAsSynced(cloudVoucher),
        );
      } catch (error, stackTrace) {
        _logger.error(
          'Failed to store Firestore voucher ${cloudVoucher.id} locally.',
          error: error,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Voucher _markAsSynced(Voucher voucher) {
    return voucher.copyWith(
      syncStatus: 'synced',
      syncedAt: voucher.syncedAt ?? DateTime.now().toUtc().toIso8601String(),
    );
  }

  String _userFriendlyError(Object error) {
    final message = error.toString().trim();
    if (message.isEmpty) {
      return 'Unknown sync error';
    }
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length).trim();
    }
    return message;
  }
}
