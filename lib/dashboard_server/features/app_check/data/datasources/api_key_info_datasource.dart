import 'package:dart_verse_backend/constants/collections.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_hash_model.dart';
import 'package:dart_verse_backend/errors/models/api_key_exceptions.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

List<ApiHashModel> _apiKeysHashes = [];

ApiHashModel? _getFromSaved(String apiHash) {
  ApiHashModel? savedModel = _apiKeysHashes.cast().firstWhere(
        (element) => element.apiHash == apiHash,
        orElse: () => null,
      );
  return savedModel;
}

void _addToSavedKeys(ApiHashModel model) {
  bool exist =
      _apiKeysHashes.any((element) => element.apiHash == model.apiHash);
  if (exist) return;
  _apiKeysHashes.add(model);
}

void _addAllToSavedKeys(List<ApiHashModel> models) {
  for (var model in models) {
    _addToSavedKeys(model);
  }
}

void _updateSavedKeys(ApiHashModel model) {
  int index =
      _apiKeysHashes.indexWhere((element) => element.apiHash == model.apiHash);
  if (index == -1) {
    return;
  }
  _apiKeysHashes[index] = model;
}

void _deleteSavedKey(String hash) {
  _apiKeysHashes.removeWhere((element) => element.apiHash == hash);
}

class ApiKeyInfoDatasource {
  final DbService _dbService;
  final String _encrypterSecretKey;
  late ApiKeyGenerator _generator;

  ApiKeyInfoDatasource(this._dbService, this._encrypterSecretKey) {
    _generator = ApiKeyGenerator(encrypterSecretKey: _encrypterSecretKey);
  }

  Future<ApiHashModel?> getApiModel(String apiHash) async {
    var savedModel = _getFromSaved(apiHash);
    if (savedModel != null) return savedModel;
    var doc = await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .findOne(where.eq('apiHash', apiHash));
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
    await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .insertOne(model.toJson());
    _addToSavedKeys(model);
  }

  Future<List<ApiHashModel>> listApiKeys() async {
    var docs = await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .getAllDocuments();
    var res = docs.map((e) => ApiHashModel.fromJson(e)).toList();
    _addAllToSavedKeys(res);
    return res;
  }

  Future<void> updateApiKey(ApiHashModel newModel) async {
    var selector = where.eq('apiHash', newModel.apiHash);
    var update = modify.set('active', newModel.active);
    await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .updateOne(selector, update);
    _updateSavedKeys(newModel);
  }

  Future<void> deleteApiKey(String hash) async {
    await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .deleteOne(where.eq('apiHash', hash));
    _deleteSavedKey(hash);
  }

  Future<void> toggleApiKeyActiveness(String apiHash) async {
    ApiHashModel? model = await getApiModel(apiHash);
    if (model == null) {
      throw NoApiKeyFound();
    }
    model.active != model.active;
  }
}
