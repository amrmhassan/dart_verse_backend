// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageRefModel _$StorageRefModelFromJson(Map<String, dynamic> json) =>
    StorageRefModel(
      bucketId: json['bucketName'] as String?,
      ref: json['ref'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$StorageRefModelToJson(StorageRefModel instance) =>
    <String, dynamic>{
      'bucketName': instance.bucketId,
      'ref': instance.ref,
      'type': instance.type,
    };
