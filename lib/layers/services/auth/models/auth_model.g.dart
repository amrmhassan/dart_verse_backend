// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      id: json['id'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'email': instance.email,
      'id': instance.id,
      'passwordHash': instance.passwordHash,
    };
