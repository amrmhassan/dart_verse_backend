import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_info_datasource.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/checker/api_decoder.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_hash_model.dart';
import 'package:dart_verse_backend/errors/models/api_key_exceptions.dart';
import 'package:dart_verse_backend/errors/models/app_check_exceptions.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';

class CheckAppDatasource {
  final String _secretKey;
  final String _encrypterSecretKey;
  final Duration _apiHashExpiryAfter;
  final DbService _dbService;
  late ApiKeyInfoDatasource _apiKeyInfoDatasource;

  CheckAppDatasource({
    required String secretKey,
    required String encrypterSecretKey,
    required Duration apiHashExpiryAfter,
    required DbService dbService,
  })  : _apiHashExpiryAfter = apiHashExpiryAfter,
        _encrypterSecretKey = encrypterSecretKey,
        _secretKey = secretKey,
        _dbService = dbService {
    _apiKeyInfoDatasource =
        ApiKeyInfoDatasource(_dbService, _encrypterSecretKey);
  }

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
    if (data == null || apiHash == null) {
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
    // get the api key from the database
    ApiHashModel? apiHashModel =
        await _apiKeyInfoDatasource.getApiModel(apiHash);
    // check if the api key exist in the database
    if (apiHashModel == null) {
      throw NoApiKeyFound();
    }
    // check if the api key is active
    if (!apiHashModel.active) {
      throw InactiveApiKey();
    }
    // check for the expiration date of the api key
    var apiInfoModel = apiHashModel.toApiKey(_encrypterSecretKey);
    bool expired = apiInfoModel.expired;
    if (expired) {
      throw ExpiredApiKey();
    }
  }
}
