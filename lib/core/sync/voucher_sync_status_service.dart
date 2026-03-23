import 'package:shared_preferences/shared_preferences.dart';

class VoucherSyncStatusService {
  const VoucherSyncStatusService();

  static const String _lastSyncedAtKey = 'voucher_sync_last_synced_at';

  Future<String?> loadLastSyncedAtIso() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_lastSyncedAtKey);
  }

  Future<bool> saveLastSyncedAtIso(String iso) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.setString(_lastSyncedAtKey, iso);
  }
}
