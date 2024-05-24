import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    await storage.write(key: key, value: value);
    if (kDebugMode) {
      print('Data written to secure storage: $key = $value');
    }
  }

  Future<String> readSecureData(String key) async {
    String value = await storage.read(key: key) ?? 'no data';
    if (kDebugMode) {
      print('Data read from secure storage: $key = $value');
    }
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    await storage.delete(key: key);
    if (kDebugMode) {
      print('Data deleted from secure storage: $key');
    }
  }
}
