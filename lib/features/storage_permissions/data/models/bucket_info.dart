import 'package:json_annotation/json_annotation.dart';
part 'bucket_info.g.dart';

@JsonSerializable()
class BucketInfo {
  final String id;
  final String path;
  final String? creatorId;
  final String createdAt;
  final int? maxAllowedSize;

  const BucketInfo({
    required this.id,
    required this.path,
    required this.creatorId,
    required this.createdAt,
    required this.maxAllowedSize,
  });
  factory BucketInfo.fromJson(Map<String, dynamic> json) =>
      _$BucketInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BucketInfoToJson(this);
}
