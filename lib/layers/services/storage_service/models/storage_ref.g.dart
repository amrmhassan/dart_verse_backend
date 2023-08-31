// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_ref.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageRef _$StorageRefFromJson(Map<String, dynamic> json) => StorageRef(
      bucketName: json['bucketName'] as String,
      ref: json['ref'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$StorageRefToJson(StorageRef instance) =>
    <String, dynamic>{
      'bucketName': instance.bucketName,
      'ref': instance.ref,
      'type': instance.type,
    };
