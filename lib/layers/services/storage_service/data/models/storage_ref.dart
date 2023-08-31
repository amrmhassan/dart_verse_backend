import 'package:json_annotation/json_annotation.dart';
part 'storage_ref.g.dart';

@JsonSerializable()
class StorageRefModel {
  final String? bucketId;
  final String ref;
  final String type;

  const StorageRefModel({
    required this.bucketId,
    required this.ref,
    required this.type,
  });
  factory StorageRefModel.fromJson(Map<String, dynamic> json) =>
      _$StorageRefModelFromJson(json);
  Map<String, dynamic> toJson() => _$StorageRefModelToJson(this);
}
