import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/security/database_key_store.dart';

final class AndroidDatabaseKeyStore implements DatabaseKeyStore {
  AndroidDatabaseKeyStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(
              storageNamespace: 'abonelik_takip_database',
            ),
          );

  static const _storageKey = 'database_key_v1';
  final FlutterSecureStorage _storage;

  @override
  Future<String> readOrCreateDatabaseKey() async {
    final existing = await _storage.read(key: _storageKey);
    if (existing != null && existing.isNotEmpty) return existing;

    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    final key = base64UrlEncode(bytes).replaceAll('=', '');
    await _storage.write(key: _storageKey, value: key);
    return key;
  }
}
