import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  const DeviceIdService();

  static const String _deviceIdKey = 'device_id';
  static const Uuid _uuid = Uuid();

  Future<String> getOrCreateDeviceId() async {
    final preferences = await SharedPreferences.getInstance();
    final existing = preferences.getString(_deviceIdKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final deviceId = _uuid.v4();
    await preferences.setString(_deviceIdKey, deviceId);
    return deviceId;
  }
}
