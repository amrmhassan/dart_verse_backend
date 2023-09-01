import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/storage_permission_source.dart';
import 'package:dart_verse_backend/features/storage_permissions/utils/permissions_utils.dart';
import 'package:hive/hive.dart';

class StoragePermissionController {
  late SBBoxes _sbBoxes;

  final StorageBucket _storageBucket;
  Box? _bucketBoxSource;
  Box? _refBoxSource;

  StoragePermissionController(this._storageBucket) {
    _sbBoxes = SBBoxes(_storageBucket.id);
  }
  //? getting boxes
  Future<Box> get _bucketBox async {
    if (_bucketBoxSource != null) {
      return _bucketBoxSource!;
    }
    var box = await _sbBoxes.bucketBox();
    _bucketBoxSource = box;
    return box;
  }

  Future<Box> get _refBox async {
    if (_refBoxSource != null) {
      return _refBoxSource!;
    }
    var box = await _sbBoxes.refBox();
    _refBoxSource = box;
    return box;
  }

  // if the user id starts with ^^ then block him and ends with ^^
  // if the user id doesn't start or end with ^^ then this user is allowed
  //? handling permissions
  Future<void> addBUserPermission(
    String permissionName,
    String userId, {
    bool block = false,
  }) async {
    var box = await _bucketBox;
    List<String> permissions = box.get(permissionName) ?? [];
    // removing old permissions for that user
    permissions.remove(userId);
    permissions.remove(SPUtils.blockedIt(userId));
    if (block) {
      permissions.add(SPUtils.blockedIt(userId));
    } else {
      permissions.add(userId);
    }
    await box.put(permissionName, permissions);
  }
}
