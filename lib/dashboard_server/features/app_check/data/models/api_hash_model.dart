import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';
import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_hash_model.g.dart';

@JsonSerializable(explicitToJson: true)
@DateConverter()
class ApiHashModel {
  final String apiHash;
  bool active;
  final String apiSecretEncrypted;
  ApiHashModel(
    this.apiHash, {
    this.active = true,
    required this.apiSecretEncrypted,
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

class DateConverter extends JsonConverter<DateTime, String> {
  const DateConverter();
  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
