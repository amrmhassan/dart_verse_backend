import 'package:dart_verse/helpers/buckets_hive.dart';
import 'package:hive/hive.dart';

late Box _bucketsBox;

class BucketsStore {
  Future<void> init() async {
    await HiveHelper.init();
    _bucketsBox = await HiveHelper.bucketsBox;
  }

  static Box get bucketsBox => _bucketsBox;

  static void putBucket(String name, String path) {
    _bucketsBox.put(name, path);
  }

  static String? getBucketPath(String bucketName) {
    return _bucketsBox.get(bucketName) as String?;
  }
}
