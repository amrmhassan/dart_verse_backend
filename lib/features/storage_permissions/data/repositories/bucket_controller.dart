import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/constants/boxes_keys.dart';
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

  Future<void> _createBucketInfoBox() async {
    SBBoxes sbBoxes = SBBoxes(storageBucket.id);
    var infoBox = await sbBoxes.bucketBox();
    var savedInfo = infoBox.get(BoxesKeys.info) as Map<dynamic, dynamic>?;
    if (savedInfo != null) {
      Map<String, dynamic> cloneObj = {};
      for (var entry in savedInfo.entries) {
        cloneObj[entry.key] = entry.value;
      }
      var infoModel = BucketInfo.fromJson(cloneObj);
      await validateSavedBucketInfo(infoModel);
      _bucketInfo = infoModel;
      return;
    }

    BucketInfo info = BucketInfo(
      id: storageBucket.id,
      path: storageBucket.folderPath,
      creatorId: storageBucket.creatorId,
      createdAt: DateTime.now().toIso8601String(),
      maxAllowedSize: storageBucket.maxAllowedSize,
    );
    await infoBox.put(BoxesKeys.info, info.toJson());
    _bucketInfo = info;
  }

  Future<void> validateSavedBucketInfo(BucketInfo savedInfo) async {
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
