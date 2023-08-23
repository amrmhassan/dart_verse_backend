import 'dart:convert';

import 'package:dart_verse_backend/constants/model_fields.dart';
import 'package:dart_verse_backend/constants/reserved_keys.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  final String email;
  final String id;
  final String passwordHash;

  const AuthModel({
    required this.id,
    required this.email,
    required this.passwordHash,
  });
  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  @override
  String toString() {
    var obj = toJson();
    obj.remove(ModelFields.passwordHash);
    return json.encode(obj);
  }

  // ignore: no_leading_underscores_for_local_identifiers, non_constant_identifier_names
  Map<String, dynamic> toJsonWith_Id() {
    var map = toJson();
    map[DBRKeys.id] = id;
    return map;
  }
}
