import 'package:dart_verse_backend_new/features/storage_permissions/data/constants/boxes_keys.dart';
import 'package:dart_verse_backend_new/features/storage_permissions/data/constants/storage_permissions.dart';
import 'package:dart_verse_backend_new/features/storage_permissions/data/models/bucket_info.dart';
import 'package:hive/hive.dart';

class PermissionParser {
  static Map<String, List<String>> boxParser(Box box) {
    Map<String, List<String>> permissions = {};
    for (var key in box.keys) {
      if (!StoragePermissions.values.contains(key)) {
        continue;
      }
      var valueRaw = box.get(key);
      var value = (valueRaw as List<dynamic>).map((e) => e.toString()).toList();
      permissions[key] = value;
    }
    return permissions;
  }

  static BucketInfo? infoParser(Box bucketBox) {
    var savedInfo = bucketBox.get(BoxesKeys.info) as Map<dynamic, dynamic>?;
    if (savedInfo != null) {
      Map<String, dynamic> cloneObj = {};
      for (var entry in savedInfo.entries) {
        cloneObj[entry.key] = entry.value;
      }
      var infoModel = BucketInfo.fromJson(cloneObj);
      return infoModel;
    }
    return null;
  }
}
