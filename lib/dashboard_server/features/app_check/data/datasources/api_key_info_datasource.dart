import 'package:dart_verse_backend/constants/collections.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/repositories/api_keys_repo.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_hash_model.dart';
import 'package:dart_verse_backend/errors/models/api_key_exceptions.dart';
import 'package:dart_verse_backend/layers/services/db_manager/data/repositories/mongo_ref/coll_ref_mongo.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

ApiKeysRepo _apiKeysRepo = ApiKeysRepo();

class ApiKeyInfoDatasource {
  final DbService _dbService;
  final String _encrypterSecretKey;
  late ApiKeyGenerator _generator;
  late CollRefMongo _collection;

  ApiKeyInfoDatasource(this._dbService, this._encrypterSecretKey) {
    _generator = ApiKeyGenerator(encrypterSecretKey: _encrypterSecretKey);
    _collection =
        _dbService.mongoDbController.collection(DBCollections.apiKeys);
  }

  Future<ApiHashModel?> getApiModel(String apiHash) async {
    var savedModel = _apiKeysRepo.getFromSaved(apiHash);
    if (savedModel != null) return savedModel;
    var doc = await _collection.findOne(where.eq('apiHash', apiHash));
    if (doc == null) return null;
    var apiModel = ApiHashModel.fromJson(doc);
    return apiModel;
  }

  Future<ApiHashModel> generateApiKey(
    String name, {
    required Duration? expireAfter,
  }) async {
    String apiHash = _generator.generateApiKey(name, expireAfter: expireAfter);
    var existing = await getApiModel(apiHash);
    if (existing != null) {
      return generateApiKey(name, expireAfter: expireAfter);
    }
    ApiHashModel hashModel = ApiHashModel(apiHash);
    return hashModel;
  }

  Future<void> saveHashModel(ApiHashModel model) async {
    await _collection.insertOne(model.toJson());
    _apiKeysRepo.addToSavedKeys(model);
  }

  Future<List<ApiHashModel>> listApiKeys() async {
    var docs = await _collection.getAllDocuments();
    var res = docs.map((e) => ApiHashModel.fromJson(e)).toList();
    _apiKeysRepo.addAllToSavedKeys(res);
    return res;
  }

  Future<void> updateApiKey(ApiHashModel newModel) async {
    var selector = where.eq('apiHash', newModel.apiHash);
    var update = modify.set('active', newModel.active);
    await _collection.updateOne(selector, update);
    _apiKeysRepo.updateSavedKeys(newModel);
  }

  Future<void> deleteApiKey(String hash) async {
    await _collection.deleteOne(where.eq('apiHash', hash));
    _apiKeysRepo.deleteSavedKey(hash);
  }

  Future<void> toggleApiKeyActiveness(String apiHash) async {
    ApiHashModel? model = await getApiModel(apiHash);
    if (model == null) {
      throw NoApiKeyFound();
    }
    model.active != model.active;
  }
}
