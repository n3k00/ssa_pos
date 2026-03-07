import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

enum BluetoothPermissionResult {
  granted,
  denied,
  permanentlyDenied,
}

class BluetoothPermissionService {
  const BluetoothPermissionService._();

  static List<Permission> get _requiredPermissions => <Permission>[
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse,
      ];

  static bool get _isBypassedPlatform {
    return Platform.environment.containsKey('FLUTTER_TEST') ||
        kIsWeb ||
        defaultTargetPlatform != TargetPlatform.android;
  }

  static Future<bool> hasRequiredPermissions() async {
    if (_isBypassedPlatform) {
      return true;
    }

    try {
      for (final permission in _requiredPermissions) {
        if (!await permission.isGranted) {
          return false;
        }
      }
      return true;
    } on MissingPluginException {
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<BluetoothPermissionResult> ensureGranted() async {
    if (_isBypassedPlatform) {
      return BluetoothPermissionResult.granted;
    }

    try {
      final statuses = await _requiredPermissions.request();
      if (statuses.values.every((status) => status.isGranted)) {
        return BluetoothPermissionResult.granted;
      }
      if (statuses.values.any((status) => status.isPermanentlyDenied)) {
        return BluetoothPermissionResult.permanentlyDenied;
      }
      return BluetoothPermissionResult.denied;
    } on MissingPluginException {
      return BluetoothPermissionResult.granted;
    } catch (_) {
      return BluetoothPermissionResult.denied;
    }
  }
}
