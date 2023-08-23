import 'dart:io';

import 'package:dart_verse/layers/services/storage_buckets/acm_permissions/controller/acm_permission_controller.dart';
import 'package:dart_verse/layers/services/storage_buckets/impl/default_bucket_controller.dart';
import 'package:dart_verse/layers/services/storage_buckets/repo/bucket_controller_repo.dart';
import 'package:dart_verse/utils/string_utils.dart';
import 'package:path/path.dart';

String get defaultBucketsContainer => 'Buckets';

class StorageBucket {
  /// this name is it's id, should be unique
  /// must only contain numbers and letters and not exceed 50 letters
  final String name;

  /// this is the maximum allowed bucket size in bytes
  /// if null this means that the bucket size can be infinity
  final int? maxAllowedSize;

  /// if empty this will create an empty folder in the root path of the project with the name of the storage bucket name
  /// just try not to keep it null
  late String _parentPath;

  /// this is the controller for bucket operations like creating validating and much more
  /// if null, this bucket controller will be assigned to a default bucket controller
  late BucketControllerRepo _controller;
  late ACMPermissionController _permissionsController;

  final String creatorId;

  StorageBucket(
    this.name, {
    String? parentFolderPath,
    this.maxAllowedSize,
    BucketControllerRepo? controller,
    required this.creatorId,
  }) {
    _controller = controller ?? DefaultBucketController(this);
    _parentPath = parentFolderPath ?? defaultBucketsContainer;
    _parentPath = _parentPath.replaceAll('//', '/');
    _parentPath = _parentPath.replaceAll('\\', '/');
    _parentPath = _parentPath.strip('/');
    _controller.createBucket();
    _permissionsController = ACMPermissionController(this);
  }

  String get folderPath => '$_parentPath/$name';
  String get parentPath => _parentPath;
  BucketControllerRepo get controller => _controller;
  ACMPermissionController get permissionsController => _permissionsController;

  StorageBucket child(String name) {
    return StorageBucket(
      name,
      parentFolderPath: folderPath,
      creatorId: creatorId,
    );
  }

  ///? this will migrate from the requested bucket in the headers to <br>
  ///? another bucket reached from the ref, but the allowing rules will be applied from the referenced bucket <br>
  ///? but if there is no storage bucket from the ref, this will return the original bucket with it's rule <br>
  ///? and the ref will only be used as a sub dir inside the original bucket <br>
  ///? so that ref method must return the nearest bucket in the path from it's end <br>
  ///? like if the path is /{storage}/users/{amr}/images <br>
  ///? if this is the ref and the {} means this is a bucket then the amr bucket will be returned from this path <br>
  ///? so this must return a bucket
  ///? but not necessarily the current bucket
  StorageBucket ref(String path) {
    List<String> iterations = path.strip('/').split('/');
    StorageBucket? bucketFromPath = fromPath(path);
    if (bucketFromPath == null && iterations.length == 1) {
      // return the current storage bucket if the ref is just one
      return this;
    }
    if (bucketFromPath == null) {
      String newPath = iterations.sublist(0, iterations.length - 1).join('/');
      return ref(newPath);
    } else {
      return bucketFromPath;
    }
    // List<String> iterations = path.strip('/').split('/');
    // String localFolderPath =
    //     iterations.sublist(0, iterations.length - 1).join('/');
    // var res = StorageBucket(
    //   iterations.last,
    //   parentFolderPath: '$folderPath/$localFolderPath',
    //   creatorId: creatorId,
    // );
    // return res;
  }

//! every storage bucket must contain .acm file which will contain it's permissions
//! write
//! read
//! delete
//!
//@ the creatorId will be stored in the bucket itself as a file containing the id of the creator
// in this method parent i will know about a storage bucket by it's .acm file
  StorageBucket? parent() {
    try {
      String parentPath = Directory(folderPath).parent.path;
      return StorageBucket.fromPath(parentPath);
    } catch (e) {
      return null;
    }
  }

  static StorageBucket? fromPath(String path) {
    String acmFileName = ACMPermissionController.acmFileName;
    String acmFilePath = '${path.strip('/')}/$acmFileName';
    var acm = ACMPermissionController.isAcmFileValid(acmFilePath);
    if (acm == null) return null;
    // here this means that the acm file is valid
    var name = basename(path);
    String creatorId = acm['creator_id'];
    int? maxSize = acm['max_size'];
    Directory directory = Directory(path);
    return StorageBucket(
      name,
      creatorId: creatorId,
      maxAllowedSize: maxSize,
      parentFolderPath: directory.parent.path,
    );
  }

  bool containFile(String path) {
    String bucketPath = folderPath.strip('./');
    if (path.contains(bucketPath)) {
      return true;
    }
    return false;
  }

  String? getFileRef(FileSystemEntity entity) {
    if (!containFile(entity.path)) return null;
    String bucketPath = folderPath;
    // file path: /path/to/bucket/bucket_name/sub/dir/file.ext
    // bucket path: /path/to/bucket/bucket_name
    // desired output : sub/dir/file.ext
    var parts = entity.path.split(bucketPath);
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
