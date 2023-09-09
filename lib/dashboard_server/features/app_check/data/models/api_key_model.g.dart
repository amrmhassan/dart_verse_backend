// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKeyModel _$ApiKeyModelFromJson(Map<String, dynamic> json) => ApiKeyModel(
      name: json['name'] as String,
      apiKey: json['apiKey'] as String,
      createdAt: const DateConverter().fromJson(json['createdAt'] as String),
      expiryDate: _$JsonConverterFromJson<String, DateTime>(
          json['expiryDate'], const DateConverter().fromJson),
    );

Map<String, dynamic> _$ApiKeyModelToJson(ApiKeyModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'apiKey': instance.apiKey,
      'createdAt': const DateConverter().toJson(instance.createdAt),
      'expiryDate': _$JsonConverterToJson<String, DateTime>(
          instance.expiryDate, const DateConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
