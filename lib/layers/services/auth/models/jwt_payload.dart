import 'package:json_annotation/json_annotation.dart';

part 'jwt_payload.g.dart';

@JsonSerializable()
class JWTPayloadModel {
  final String id;
  final String email;
  final String? ip;
  final String? createdAt;
  final Map<String, dynamic> other;

  const JWTPayloadModel({
    required this.id,
    required this.email,
    required this.ip,
    required this.createdAt,
    required this.other,
  });
  factory JWTPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$JWTPayloadModelFromJson(json);
  Map<String, dynamic> toJson() => _$JWTPayloadModelToJson(this);
}
