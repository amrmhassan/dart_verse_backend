// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bucket_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BucketInfo _$BucketInfoFromJson(Map<String, dynamic> json) => BucketInfo(
      id: json['id'] as String,
      path: json['path'] as String,
      creatorId: json['creatorId'] as String?,
      createdAt: json['createdAt'] as String,
      maxAllowedSize: json['maxAllowedSize'] as int?,
    );

Map<String, dynamic> _$BucketInfoToJson(BucketInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'path': instance.path,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt,
      'maxAllowedSize': instance.maxAllowedSize,
    };
