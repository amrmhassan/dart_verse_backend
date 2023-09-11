import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/constants/boxes_keys.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/permission_parser.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/storage_permission_source.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/models/bucket_info.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/utils/string_utils.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:path/path.dart';

List<String> reservedBucketsName = ['null'];
String _validChars = 'abcdefghijklmnopqrstuvwxyz0123456789';

bool _valid(String name) {
  if (reservedBucketsName.contains(name)) {
    throw Exception('can\'t use from reserved names: $reservedBucketsName');
  }
  var letters = name.toLowerCase().split('');
  for (var letter in letters) {
    if (!_validChars.contains(letter)) {
      return false;
    }
  }
  return true;
}

class BucketController {
  final StorageBucket storageBucket;
  BucketInfo? _bucketInfo;
  BucketInfo get bucketInfo {
    if (_bucketInfo == null) {
      throw BucketNotInitiated();
    }
    return _bucketInfo!;
  }

  BucketController(this.storageBucket);

  Future<void> createBucket() async {
    _validateBucketInfo();

    // validating bucket folder path
    Directory directory = Directory(storageBucket.folderPath);
    if (!directory.existsSync()) {
      try {
        directory.createSync(recursive: true);
        // here just add the bucket id to the buckets data
        _saveBucketId();
      } catch (e) {
        throw StorageBucketFolderPathException(
            'can\'t create the bucket folder, $e');
      }
    }
    // check if the storage bucket is created or not
    if (!directory.existsSync()) {
      throw StorageBucketFolderPathException('bucket folder wasn\'t created');
    }
    await _createBucketInfoBox();
  }

  Future<BucketInfo> _createBucketInfoBox() async {
    SBBoxes sbBoxes = SBBoxes(storageBucket.id);
    BucketInfo? savedInfo = await _fromBoxes(sbBoxes);
    if (savedInfo != null) {
      _validateSavedBucketInfo(savedInfo);
      _bucketInfo = savedInfo;
      return savedInfo;
    }

    BucketInfo info = BucketInfo(
      id: storageBucket.id,
      path: storageBucket.folderPath,
      creatorId: storageBucket.creatorId,
      createdAt: DateTime.now().toIso8601String(),
      maxAllowedSize: storageBucket.maxAllowedSize,
    );
    var infoBox = await sbBoxes.bucketBox();
    await infoBox.put(BoxesKeys.info, info.toJson());
    return info;
  }

  static Future<BucketInfo?> _fromBoxes(SBBoxes sbBoxes) async {
    var infoBox = await sbBoxes.bucketBox();
    return PermissionParser.infoParser(infoBox);
  }

  void _validateSavedBucketInfo(BucketInfo savedInfo) {
    if (storageBucket.folderPath.strip('/') != savedInfo.path.strip('/')) {
      throw ProhebitedBucketEditException();
    }
  }

  void _validateBucketInfo() {
    // validating bucket name
    if (storageBucket.id.length > 50) {
      throw StorageBucketNameException('exceeded 50 letters');
    }
    if (!_valid(storageBucket.id)) {
      throw StorageBucketNameException(storageBucket.id);
    }
    String baseName = basename(storageBucket.folderPath);
    if (baseName == '..' || baseName == '.') {
      throw StorageBucketFolderPathException();
    }
  }

  void _saveBucketId() {
    String name = storageBucket.id;
    String path = storageBucket.folderPath;
    var bucketExist = BucketsStore.bucketsBox.get(name);
    if (bucketExist != null) {
      if (bucketExist != path) {
        throw StorageBucketExistsException(name);
      }
    }

    BucketsStore.putBucket(name, path);
  }

  Directory _bucketDir() {
    Directory directory = Directory(storageBucket.folderPath);
    return directory;
  }

  static Future<BucketInfo?> fromPath(String bucketPath) async {
    try {
      SBBoxes sbBoxes = SBBoxes.fromPath(bucketPath);
      BucketInfo? info = await _fromBoxes(sbBoxes);
      if (info == null) {
        // here i will create and initialize the bucket and return it's info
      }
      return info;
    } catch (e) {
      return null;
    }
  }

  //? bucket operations
  Future<File> receiveFile(
    RequestHolder request, {
    bool throwErrorIfExist = false,
    bool overrideIfExist = false,
    String? fileName,
  }) async {
    String folderPath = storageBucket.targetRefPath;
    final file = await request.receiveFile(
      folderPath,
      overrideIfExist: overrideIfExist,
      throwErrorIfExist: throwErrorIfExist,
      fileName: fileName,
    );
    // storageBucket.permissionsController.per

    return file;
  }

  Future<void> deleteBucket() async {
    Directory dir = _bucketDir();
    String name = storageBucket.id;
    // deleting the bucket from the buckets paths map
    await BucketsStore.bucketsBox.delete(name);
    // delete the bucket folder
    await dir.delete(recursive: true);
  }
}
