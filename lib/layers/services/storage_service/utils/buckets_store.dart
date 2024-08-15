import 'package:dart_verse_backend_new/helpers/buckets_hive.dart';
import 'package:hive/hive.dart';

late Box _bucketsBox;

class BucketsStore {
  Future<void> init() async {
    await HiveHelper.init();
    _bucketsBox = await HiveHelper.bucketsBox;
  }

  static Box get bucketsBox => _bucketsBox;

  static Future<void> putBucket(String id, String path) async {
    await _bucketsBox.put(id, path);
  }

  static String? getBucketPath(String id) {
    String? path = _bucketsBox.get(id) as String?;
    return path;
  }
}
