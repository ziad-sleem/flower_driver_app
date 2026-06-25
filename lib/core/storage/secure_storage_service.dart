import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tracking_app/core/resources/app_value.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: AppKeys.tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: AppKeys.tokenKey);
  }

  static Future<void> saveDriverId(String driverId) async {
    await _storage.write(key: AppKeys.driverIdKey, value: driverId);
  }

  static Future<String?> getDriverId() async {
    return await _storage.read(key: AppKeys.driverIdKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: AppKeys.tokenKey);
  }
}
