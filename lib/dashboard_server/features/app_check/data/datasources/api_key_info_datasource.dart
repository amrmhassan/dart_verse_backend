import 'package:dart_verse_backend/constants/collections.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

class ApiKeyInfoDatasource {
  final DbService _dbService;
  const ApiKeyInfoDatasource(this._dbService);

  Future<ApiKeyModel?> getApiModel(String apiKey) async {
    var doc = await _dbService.mongoDbController
        .collection(DBCollections.apiKeys)
        .findOne(where.eq('apiKey', apiKey));
    if (doc == null) return null;
    var apiModel = ApiKeyModel.fromJson(doc);
    return apiModel;
  }

  // Future<ApiKeyModel> generateApiKey(String name) async {
  // here i will generate an api key
  // }
}
