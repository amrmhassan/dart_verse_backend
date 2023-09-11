// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_hash_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiHashModel _$ApiHashModelFromJson(Map<String, dynamic> json) => ApiHashModel(
      json['apiHash'] as String,
      active: json['active'] as bool? ?? true,
      apiSecretEncrypted: json['apiSecretEncrypted'] as String,
    );

Map<String, dynamic> _$ApiHashModelToJson(ApiHashModel instance) =>
    <String, dynamic>{
      'apiHash': instance.apiHash,
      'active': instance.active,
      'apiSecretEncrypted': instance.apiSecretEncrypted,
    };
