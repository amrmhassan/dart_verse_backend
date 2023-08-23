import 'dart:async';
import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/layers/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_buckets/repo/bucket_controller_repo.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:path/path.dart';

List<String> reservedBucketsName = ['null'];

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

String _validChars = 'abcdefghijklmnopqrstuvwxyz0123456789';

class DefaultBucketController implements BucketControllerRepo {
  Directory _bucketDir() {
    Directory directory = Directory(storageBucket.folderPath);
    if (!directory.existsSync()) {
      throw BucketNotCreatedException(' from DefaultBucketController');
    }
    return directory;
  }

  @override
  void createBucket() {
    validateBucketInfo();

    // validating bucket folder path
    Directory directory = Directory(storageBucket.folderPath);
    if (!directory.existsSync()) {
      try {
        directory.createSync(recursive: true);
        // here just add the bucket id to the buckets data
        saveBucketId();
      } catch (e) {
        throw StorageBucketFolderPathException(
            'can\'t create the bucket folder, $e');
      }
    }
    // check if the storage bucket is created or not
    if (!directory.existsSync()) {
      throw StorageBucketFolderPathException('bucket folder wasn\'t created');
    }
  }

  @override
  Future<int> getBucketSize() {
    Directory dir = _bucketDir();
    int size = 0;
    Completer<int> completer = Completer<int>();
    var sub = dir.list(recursive: true).listen((event) async {
      var fileStats = await event.stat();
      if (fileStats.type == FileSystemEntityType.file) {
        size += fileStats.size;
      }
    });

    sub.onDone(() async {
      completer.complete(size);
      await sub.cancel();
    });
    return completer.future;
  }

  @override
  StorageBucket storageBucket;

  DefaultBucketController(this.storageBucket);

  @override
  void validateBucketInfo() {
    // validating bucket name
    if (storageBucket.name.length > 50) {
      throw StorageBucketNameException('exceeded 50 letters');
    }
    if (!_valid(storageBucket.name)) {
      throw StorageBucketNameException(storageBucket.name);
    }
    String baseName = basename(storageBucket.folderPath);
    if (baseName == '..' || baseName == '.') {
      throw StorageBucketFolderPathException();
    }
  }

  @override
  Future<void> deleteBucket() {
    Directory dir = _bucketDir();
    return dir.delete(recursive: true);
  }

  @override
  Future<File> receiveFile(RequestHolder request
      // , {
      /// if allowed is null, it will default value equal to the bucket permissions
      // required List<ACMPermission>? allowed,
      // }
      ) async {
    final file = await request.receiveFile(storageBucket.folderPath);
    // storageBucket.permissionsController.per

    return file;
  }

  @override
  void saveBucketId() {
    String name = storageBucket.name;
    String path = storageBucket.folderPath;
    var bucketExist = BucketsStore.bucketsBox.get(name);
    if (bucketExist != null) {
      if (bucketExist != path) {
        throw StorageBucketExistsException(name);
      }
    }

    BucketsStore.putBucket(name, path);
  }
}
