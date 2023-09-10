import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/checker/base64_encrypter.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/random_generator.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_secret_model.dart';
import 'package:dart_verse_backend/errors/models/encryption_exceptions.dart';

class ApiSecretGenerator {
  final String _encrypterSecretKey;
  const ApiSecretGenerator(this._encrypterSecretKey);

  ApiSecretModel generate(String apiHash) {
    String randomString = RandomGenerator().generate(20);
    Base64Encrypter generator = Base64Encrypter(randomString);
    String? apiSecret = generator.encrypt(apiHash);
    if (apiSecret == null) {
      throw EncryptionException('can\'t generate the secret');
    }
    Base64Encrypter encrypter = Base64Encrypter(_encrypterSecretKey);
    String? secretEncrypted = encrypter.encrypt(apiSecret);
    if (secretEncrypted == null) {
      throw EncryptionException();
    }
    ApiSecretModel apiSecretModel = ApiSecretModel(
      secret: apiSecret,
      secretEncrypted: secretEncrypted,
    );
    return apiSecretModel;
  }
}
