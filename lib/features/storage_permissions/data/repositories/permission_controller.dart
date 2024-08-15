import 'package:dart_verse_backend_new/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend_new/features/storage_permissions/data/datasources/storage_permission_source.dart';
import 'package:dart_verse_backend_new/features/storage_permissions/utils/path_utils.dart';
import 'package:dart_verse_backend_new/features/storage_permissions/utils/permissions_utils.dart';
import 'package:hive/hive.dart';

//? the ref permissions is as it's bucket permissions as long as the ref doesn't have any permissions defined for it
//? so if the bucket is all private but the ref permissions is public, this ref will be public

class StoragePermissionController {
  late SBBoxes _sbBoxes;

  final StorageBucketModel _storageBucket;
  Box? _bucketBoxSource;

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

  // if the user id starts with ^^ then block him and ends with ^^
  // if the user id doesn't start or end with ^^ then this user is allowed

  Future<void> _handleEditBoxPermission({
    required Box box,
    required String permissionName,
    required String userId,
    required bool block,
  }) async {
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

  Future<Box> _refBox(String ref) async {
    String id = await _getRefId(ref);
    String boxPath = '${_sbBoxes.dataDir.path}/$id';
    var box = await Hive.openBox(id, path: boxPath);
    return box;
  }

  Future<String> _getRefId(String ref) async {
    // first search for the saved refs
    int refId = PathUtils.filePathHash(ref);
    return refId.toString();
  }

  //? handling permissions
  Future<void> addBUserPermission(
    String permissionName,
    String userId, {
    bool block = false,
  }) async {
    var box = await _bucketBox;
    return _handleEditBoxPermission(
      box: box,
      permissionName: permissionName,
      userId: userId,
      block: block,
    );
  }

  Future<void> addRefPermissions(
    String permissionName,
    String userId,
    String ref, {
    bool block = false,
  }) async {
    var box = await _refBox(ref);
    return _handleEditBoxPermission(
      box: box,
      permissionName: permissionName,
      userId: userId,
      block: block,
    );
  }
}
