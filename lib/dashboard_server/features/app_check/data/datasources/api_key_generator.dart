// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/checker/base64_encrypter.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:dart_verse_backend/errors/models/encryption_exceptions.dart';

class ApiKeyGenerator {
  final String _encrypterSecretKey;
  late Base64Encrypter _encrypter;
  ApiKeyGenerator({
    required String encrypterSecretKey,
  }) : _encrypterSecretKey = encrypterSecretKey {
    _encrypter = Base64Encrypter(_encrypterSecretKey);
  }

  String generateApiKey(
    String appName, {
    required Duration? expireAfter,
  }) {
    DateTime createdAt = DateTime.now();
    String random = _generateRandomString(10);
    ApiKeyModel model = ApiKeyModel(
      name: appName,
      apiKey: random,
      createdAt: createdAt,
      expireAfter: expireAfter,
    );
    String fullQuery = model.toQuery();
    String? encrypted = _encrypter.encrypt(fullQuery);
    if (encrypted == null) {
      throw EncryptionException('Can\'t create the encrypted String');
    }
    return encrypted;
  }

  ApiKeyModel parseApiHash(String base64String) {
    String? query = _encrypter.decrypt(base64String);
    if (query == null) {
      throw DecryptionException('Can\'t create the decrypted String');
    }
    ApiKeyModel model = ApiKeyModel.fromQuery(query);
    return model;
  }

  String _generateRandomString(int length) {
    final random = Random.secure();
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String apiKey = '';

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(charset.length);
      apiKey += charset[randomIndex];
    }

    return apiKey;
  }
}
