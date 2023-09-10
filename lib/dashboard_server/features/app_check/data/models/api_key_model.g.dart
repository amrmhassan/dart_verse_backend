// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiKeyModel _$ApiKeyModelFromJson(Map<String, dynamic> json) => ApiKeyModel(
      name: json['name'] as String,
      apiKey: json['apiKey'] as String,
      createdAt: const DateConverter().fromJson(json['createdAt'] as String),
      expireAfter: json['expireAfter'] == null
          ? null
          : Duration(microseconds: json['expireAfter'] as int),
    );

Map<String, dynamic> _$ApiKeyModelToJson(ApiKeyModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'apiKey': instance.apiKey,
      'createdAt': const DateConverter().toJson(instance.createdAt),
      'expireAfter': instance.expireAfter?.inMicroseconds,
    };
