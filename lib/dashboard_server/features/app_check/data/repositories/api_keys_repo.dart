import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/models/api_hash_model.dart';

class ApiKeysRepo {
  final List<ApiHashModel> _apiKeysHashes = [];

  ApiHashModel? getFromSaved(String apiHash) {
    ApiHashModel? savedModel = _apiKeysHashes.cast().firstWhere(
          (element) => element.apiHash == apiHash,
          orElse: () => null,
        );
    return savedModel;
  }

  void addToSavedKeys(ApiHashModel model) {
    bool exist =
        _apiKeysHashes.any((element) => element.apiHash == model.apiHash);
    if (exist) return;
    _apiKeysHashes.add(model);
  }

  void addAllToSavedKeys(List<ApiHashModel> models) {
    for (var model in models) {
      addToSavedKeys(model);
    }
  }

  void updateSavedKeys(ApiHashModel model) {
    int index = _apiKeysHashes
        .indexWhere((element) => element.apiHash == model.apiHash);
    if (index == -1) {
      return;
    }
    _apiKeysHashes[index] = model;
  }

  void deleteSavedKey(String hash) {
    _apiKeysHashes.removeWhere((element) => element.apiHash == hash);
  }
}
