// ignore_for_file: prefer_const_constructors

import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/datasources/checker/base64_encrypter.dart';
import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/datasources/random_generator.dart';
import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:dart_verse_backend_new/errors/models/encryption_exceptions.dart';

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
    String random = RandomGenerator().generate(10);
    ApiKeyModel model = ApiKeyModel(
      name: appName,
      apiKey: random,
      createdAt: createdAt,
      expireAfter: expireAfter,
    );
    String fullQuery = model.toQuery();
    String? encrypted = _encrypter.encrypt(fullQuery);
    if (encrypted == null) {
      throw EncryptionException();
    }
    return encrypted;
  }

  ApiKeyModel parseApiHash(String base64String) {
    String? query = _encrypter.decrypt(base64String);
    if (query == null) {
      throw DecryptionException();
    }
    ApiKeyModel model = ApiKeyModel.fromQuery(query);
    return model;
  }
}
