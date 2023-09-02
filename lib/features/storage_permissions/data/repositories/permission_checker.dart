import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/permission_parser.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/storage_permission_source.dart';
import 'package:dart_verse_backend/features/storage_permissions/utils/path_utils.dart';
import 'package:dart_verse_backend/features/storage_permissions/utils/permissions_utils.dart';
import 'package:hive/hive.dart';

class PermissionChecker {
  final StorageBucket _storageBucket;
  late SBBoxes _sbBoxes;

  PermissionChecker(this._storageBucket) {
    _sbBoxes = SBBoxes(_storageBucket.id);
  }

  Box? _bucketBoxSource;

  Future<Box> get _bucketBox async {
    if (_bucketBoxSource != null) {
      return _bucketBoxSource!;
    }
    var box = await _sbBoxes.bucketBox();
    _bucketBoxSource = box;
    return box;
  }

  Future<Box?> _refBox(String ref) async {
    String id = await _getRefId(ref);
    String boxPath = '${_sbBoxes.dataDir.path}/$id';
    var exists = await Hive.boxExists(id, path: boxPath);
    if (!exists) {
      return null;
    } else {
      var box = await Hive.openBox(id, path: boxPath);
      return box;
    }
  }

  Future<String> _getRefId(String ref) async {
    // first search for the saved refs
    int refId = PathUtils.filePathHash(ref);
    return refId.toString();
  }

  Future<bool> userAllowedRef({
    required String permissionName,
    required String userId,
    required String ref,
  }) async {
    var refBox = await _refBox(ref);
    if (refBox == null) {
      return userAllowed(permissionName: permissionName, userId: userId);
    }
    //
    var bucketBox = await _bucketBox;
    return _allowedFromBox(
      box: refBox,
      permissionName: permissionName,
      userId: userId,
      bucketBox: bucketBox,
    );
  }

  Future<bool> userAllowed({
    required String permissionName,
    required String userId,
  }) async {
    var bucketBox = await _bucketBox;
    return _allowedFromBox(
      box: bucketBox,
      permissionName: permissionName,
      userId: userId,
      bucketBox: bucketBox,
    );
  }

  Future<bool> _allowedFromBox({
    required Box box,
    required String permissionName,
    required String userId,
    required Box bucketBox,
  }) async {
    var permission = box.get(permissionName);
    if (permission == null) {
      return true;
    }
    //
    var data = PermissionParser.boxParser(box);
    List<String>? users = data[permissionName];
    if (users == null) {
      //? here is the default value
      return true;
    }
    // blocking blocked user
    String blockedUser = SPUtils.blockedIt(userId);
    if (users.contains(blockedUser)) {
      return false;
    }
    // allowing allowed user
    if (users.contains(userId)) {
      return true;
    }
    // allowing for public access
    if (users.contains(SPUtils.allUsers)) {
      return true;
    }
    // allowing the creator id
    var info = PermissionParser.infoParser(box);
    if (info == null) {
      return false;
    }
    return info.creatorId == userId;
  }
}
