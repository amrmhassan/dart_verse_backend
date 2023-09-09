import 'package:dart_verse_backend/constants/collections.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_hash_model.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ApiKeyInfoDatasource {
  final DbService _dbService;
  final String _encrypterSecretKey;
  late ApiKeyGenerator _generator;

  ApiKeyInfoDatasource(this._dbService, this._encrypterSecretKey) {
    _generator = ApiKeyGenerator(encrypterSecretKey: _encrypterSecretKey);
  }

  Future<ApiKeyModel?> getApiModel(String apiHash) async {
    var doc = await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .findOne(where.eq('apiHash', apiHash));
    if (doc == null) return null;
    var apiModel = ApiHashModel.fromJson(doc);
    var model = apiModel.toApiKey(_encrypterSecretKey);
    return model;
  }

  Future<ApiHashModel> generateApiKey(String name) async {
    String apiHash = _generator.generateApiKey(name);
    var existing = await getApiModel(apiHash);
    if (existing != null) {
      return generateApiKey(name);
    }
    ApiHashModel hashModel = ApiHashModel(apiHash);
    return hashModel;
  }

  Future<void> saveHashModel(ApiHashModel model) async {
    await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .insertOne(model.toJson());
  }
}
