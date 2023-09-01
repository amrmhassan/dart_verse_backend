import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/constants/permissions_constants.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/utils/string_utils.dart';
import 'package:hive/hive.dart';

class SBBoxes {
  late Directory _dataDir;
  final String _bucketId;
  SBBoxes(this._bucketId, {String? bucketPath}) {
    _dataDir = _handleInitDataDir(bucketPath);
  }

  factory SBBoxes.fromPath(String path) {
    return SBBoxes('_bucketId', bucketPath: path);
  }

  Directory _handleInitDataDir([String? passedBucketPath]) {
    if (passedBucketPath == null) {
      passedBucketPath = BucketsStore.getBucketPath(_bucketId);
      if (passedBucketPath == null) {
        throw NoBucketException(_bucketId);
      }
    }
    // here handle open the bucket box
    Directory bucketDataDir = _checkBucketDataDir(passedBucketPath);
    return bucketDataDir;
  }

  Directory _checkBucketDataDir(String bucketPath) {
    Directory directory =
        Directory('${bucketPath.strip('/')}/${SPConstants.bucketAcmFolder}');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

//? this will return the box for the bucket info, permissions
  Future<Box> bucketBox() async {
    Box box = await Hive.openBox(SPConstants.bucketPermissionsBox,
        path: _dataDir.path);
    return box;
  }

//? this will return the box for the refs inside the bucket
  Future<Box> refMapBox() async {
    Box box =
        await Hive.openBox(SPConstants.redMappingBox, path: _dataDir.path);
    return box;
  }
}
