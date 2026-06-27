import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tracking_app/core/resources/app_value.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: AppKeys.tokenKey, value: token);

    final driverId = extractDriverIdFromToken(token);
    if (driverId != null && driverId.isNotEmpty) {
      await _storage.write(key: AppKeys.driverIdKey, value: driverId);
    }
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: AppKeys.tokenKey);
  }

  static Future<void> saveDriverId(String driverId) async {
    await _storage.write(key: AppKeys.driverIdKey, value: driverId);
  }

  static Future<String?> getDriverId() async {
    final cachedDriverId = await _storage.read(key: AppKeys.driverIdKey);
    if (cachedDriverId != null && cachedDriverId.isNotEmpty) {
      return cachedDriverId;
    }

    final token = await getToken();
    final driverId = extractDriverIdFromToken(token);
    if (driverId != null && driverId.isNotEmpty) {
      await _storage.write(key: AppKeys.driverIdKey, value: driverId);
    }

    return driverId;
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: AppKeys.tokenKey);
    await _storage.delete(key: AppKeys.driverIdKey);
  }

  static String? extractDriverIdFromToken(String? token) {
    if (token == null || token.isEmpty) {
      return null;
    }

    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }

    try {
      final payload = parts[1];
      final normalizedPayload = base64Url.normalize(payload);
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final decodedJson = jsonDecode(decodedPayload);

      if (decodedJson is! Map<String, dynamic>) {
        return null;
      }

      final driverId = decodedJson['driver'] ?? decodedJson['sub'];
      if (driverId is String && driverId.isNotEmpty) {
        return driverId;
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
