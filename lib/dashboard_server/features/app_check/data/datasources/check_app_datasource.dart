import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/checker/api_decoder.dart';
import 'package:dart_verse_backend/errors/models/app_check_exceptions.dart';

List<String> allowedAppIds = ['This is the encrypter key'];

class CheckAppDatasource {
  final String _secretKey;
  final String _encrypterSecretKey;
  final Duration _apiHashExpiryAfter;

  const CheckAppDatasource({
    required String secretKey,
    required String encrypterSecretKey,
    required Duration apiHashExpiryAfter,
  })  : _apiHashExpiryAfter = apiHashExpiryAfter,
        _encrypterSecretKey = encrypterSecretKey,
        _secretKey = secretKey;

  ApiKeyData? _getApiFromHash(String? apiHash) {
    ApiDecoder decoder = ApiDecoder(
      secretKey: _secretKey,
      encrypterSecretKey: _encrypterSecretKey,
    );
    ApiKeyData? validApi = decoder.getValidApi(apiHash);
    return validApi;
  }

  /// this will throw an error if the api key is not valid
  /// other wise it will continue without any errors
  Future<void> validateApiHash(String? apiHash) async {
    var data = _getApiFromHash(apiHash);
    if (data == null) {
      throw NotAuthorizedApiKey();
    }
    //! here i must validate this api key from the database to make sure that it not expired and it is allowed and stored in the database
    DateTime now = DateTime.now();
    Duration diff = now.difference(data.createdAt);
    if (diff.isNegative) {
      throw NotValidApiKey();
    }
    if (diff.inMicroseconds > _apiHashExpiryAfter.inMicroseconds) {
      throw NotValidApiKey();
    }
  }
}
