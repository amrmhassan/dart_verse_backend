import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_hash_model.g.dart';

@JsonSerializable(explicitToJson: true)
@DateConverter()
class ApiHashModel {
  final String apiHash;
  final bool active;
  const ApiHashModel(
    this.apiHash, {
    this.active = true,
  });

  ApiKeyModel toApiKey(String encrypterSecretKey) {
    ApiKeyGenerator generator =
        ApiKeyGenerator(encrypterSecretKey: encrypterSecretKey);
    var model = generator.parseApiHash(apiHash);
    return model;
  }

  factory ApiHashModel.fromJson(Map<String, dynamic> json) =>
      _$ApiHashModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiHashModelToJson(this);
}
