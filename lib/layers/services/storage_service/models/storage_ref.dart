import 'package:json_annotation/json_annotation.dart';
part 'storage_ref.g.dart';

@JsonSerializable()
class StorageRef {
  final String bucketName;
  final String ref;
  final String type;

  const StorageRef({
    required this.bucketName,
    required this.ref,
    required this.type,
  });
}
