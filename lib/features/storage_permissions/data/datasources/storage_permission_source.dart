import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/constants/permissions_constants.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/utils/string_utils.dart';
import 'package:hive/hive.dart';

class SBBoxes {
  late Directory _dataDir;
  final String _bucketId;
  final bool create;

  SBBoxes(
    String bucketId, {
    String? bucketPath,
    this.create = false,
  }) : _bucketId = bucketId {
    _dataDir = _handleInitDataDir(bucketPath);
  }
  bool _falseId = false;
  String get bucketId {
    if (_falseId) {
      throw Exception('You can\'t access the bucket id if it was false');
    }
    return _bucketId;
  }

  factory SBBoxes.fromPath(String path) {
    //! make sure the bucketId is not accessible as long as the constructor fromPath is depending on a false bucketId
    var sbBoxes = SBBoxes('_bucketId', bucketPath: path);
    sbBoxes._falseId = true;
    return sbBoxes;
  }
  Directory get dataDir => _dataDir;

  Directory _handleInitDataDir([String? passedBucketPath]) {
    if (passedBucketPath == null) {
      passedBucketPath = BucketsStore.getBucketPath(bucketId);
      if (passedBucketPath == null) {
        throw NoBucketException(bucketId);
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
      if (create) {
        directory.createSync();
      } else {
        throw NoBucketException('bucketPath');
      }
    }
    return directory;
  }

//? this will return the box for the bucket info, permissions
  Future<Box> bucketBox() async {
    Box box = await Hive.openBox(
      SPConstants.bucketPermissionsBox,
      path: _dataDir.path,
    );
    return box;
  }
}
