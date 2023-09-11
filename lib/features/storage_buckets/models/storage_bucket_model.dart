import 'dart:io';

import 'package:dart_verse_backend/features/storage_permissions/data/models/bucket_info.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/repositories/bucket_controller.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/repositories/permission_checker.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/repositories/permission_controller.dart';
import 'package:dart_verse_backend/utils/string_utils.dart';

const String defaultBucketsContainer = 'Buckets';

class StorageBucket {
  /// this name is it's id, should be unique
  /// must only contain numbers and letters and not exceed 50 letters
  final String id;

  /// this is the maximum allowed bucket size in bytes
  /// if null this means that the bucket size can be infinity
  final int? maxAllowedSize;

  /// if empty this will create an empty folder in the root path of the project with the name of the storage bucket name
  /// just try not to keep it null
  late String _parentPath;

  /// this is the controller for bucket operations like creating validating and much more
  /// if null, this bucket controller will be assigned to a default bucket controller
  late BucketController _controller;
  late StoragePermissionController _permissionController;
  late PermissionChecker _permissionChecker;

  /// this will represent if this storage bucket targets a sub dir inside that bucket or if null this mean that this ref targets
  /// the bucket dir itself
  String? subRef;

  final String? creatorId;

  StorageBucket(
    this.id, {
    String? parentFolderPath,
    this.maxAllowedSize,
    this.subRef,
    this.creatorId,
  }) {
    _controller = BucketController(this);
    _parentPath = parentFolderPath ?? defaultBucketsContainer;
    _parentPath = _parentPath.replaceAll('//', '/');
    _parentPath = _parentPath.replaceAll('\\', '/');
    _parentPath = _parentPath.strip('/');
  }

  Future<void> init() async {
    await _controller.createBucket();
    _permissionController = StoragePermissionController(this);
    _permissionChecker = PermissionChecker(this);
  }

  String get folderPath => '$_parentPath/$id';
  String get parentPath => _parentPath;
  BucketController get controller => _controller;
  StoragePermissionController get permissionsController =>
      _permissionController;
  PermissionChecker get permissionChecker => _permissionChecker;

  StorageBucket child(String name) {
    return StorageBucket(
      name,
      parentFolderPath: folderPath,
      creatorId: creatorId,
    );
  }

//! every storage bucket must contain .acm file which will contain it's permissions
//! write
//! read
//! delete
//!
//@ the creatorId will be stored in the bucket itself as a file containing the id of the creator
// in this method parent i will know about a storage bucket by it's .acm file
  Future<StorageBucket?> parent() async {
    try {
      String parentPath = Directory(folderPath).parent.path;
      return StorageBucket.fromPath(parentPath);
    } catch (e) {
      return null;
    }
  }

  /// this will return the folder path that this storage bucket ref model targets
  String get targetRefPath {
    return subRef == null ? folderPath : '${folderPath.strip('/')}/${subRef!}';
  }

  static Future<StorageBucket?> fromPath(String path) async {
    BucketInfo? info = await BucketController.fromPath(path);
    if (info == null) return null;
    // here this means that the acm file is valid
    String? creatorId = info.creatorId;
    int? maxSize = info.maxAllowedSize;
    Directory directory = Directory(path);
    return StorageBucket(
      info.id,
      creatorId: creatorId,
      maxAllowedSize: maxSize,
      parentFolderPath: directory.parent.path,
    );
  }

  bool containFile(String path) {
    path = path.replaceAll('\\', '/');
    String bucketPath = folderPath.strip('./');
    if (path.contains(bucketPath)) {
      return true;
    }
    return false;
  }

  String? getFileRef(String entityPath) {
    entityPath = entityPath.replaceAll('\\', '/');
    if (!containFile(entityPath)) return null;

    String bucketPath = folderPath;
    // file path: /path/to/bucket/bucket_name/sub/dir/file.ext
    // bucket path: /path/to/bucket/bucket_name
    // desired output : sub/dir/file.ext
    var parts = entityPath.split(bucketPath);
    if (parts.isEmpty) {
      return null;
    }
    return parts.last.strip('/');
  }

  String? getRefAbsPath(String ref) {
    String entityPath = '${folderPath.strip('/')}/$ref';
    FileSystemEntity? entity = _entity(entityPath);
    if (entity == null) return null;

    if (!containFile(entityPath)) return null;
    return entity.path;
  }
}

FileSystemEntity? _entity(String path) {
  File file = File(path);
  if (file.existsSync()) {
    return file;
  }
  Directory directory = Directory(path);
  if (directory.existsSync()) {
    return directory;
  }
  return null;
}
