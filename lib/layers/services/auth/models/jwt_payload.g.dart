// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTPayloadModel _$JWTPayloadModelFromJson(Map<String, dynamic> json) =>
    JWTPayloadModel(
      id: json['id'] as String,
      email: json['email'] as String,
      ip: json['ip'] as String?,
      createdAt: json['createdAt'] as String,
      other: json['other'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$JWTPayloadModelToJson(JWTPayloadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'ip': instance.ip,
      'createdAt': instance.createdAt,
      'other': instance.other,
    };
