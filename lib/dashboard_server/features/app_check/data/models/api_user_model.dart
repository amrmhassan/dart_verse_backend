import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_hash_model.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_user_model.g.dart';

@JsonSerializable(explicitToJson: true)
@DateConverter()
class ApiUserModel {
  final String name;
  final String apiKey;
  final DateTime createdAt;
  final String hash;
  final bool active;
  final String secretKeyEncrypted;

  /// this can be null, to add the option to lifetime api keys
  final Duration? expireAfter;

  const ApiUserModel({
    required this.name,
    required this.apiKey,
    required this.createdAt,
    required this.expireAfter,
    required this.hash,
    required this.active,
    required this.secretKeyEncrypted,
  });
  static ApiUserModel fromModels(
    ApiKeyModel apiKeyModel,
    ApiHashModel apiHashModel,
  ) {
    return ApiUserModel(
      name: apiKeyModel.name,
      apiKey: apiKeyModel.apiKey,
      createdAt: apiKeyModel.createdAt,
      expireAfter: apiKeyModel.expireAfter,
      hash: apiHashModel.apiHash,
      active: apiHashModel.active,
      secretKeyEncrypted: apiHashModel.apiSecretEncrypted,
    );
  }

  factory ApiUserModel.fromJson(Map<String, dynamic> json) =>
      _$ApiUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiUserModelToJson(this);
}
