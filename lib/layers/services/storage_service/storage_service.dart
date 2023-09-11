import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_buckets/storage_buckets.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/datasource/storage_datasource.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/models/storage_ref.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';

class StorageService {
  final App app;
  bool _initialized = false;
  StorageService(this.app);
  final StorageDatasource _storageDatasource = StorageDatasource();
  final StorageBuckets _storageBuckets = StorageBuckets();

  Future<void> init() async {
    await BucketsStore().init();
    _initialized = true;
  }

  Future<StorageBucket> createBucket(
    String id, {
    String? parentFolderPath,
    int? maxAllowedSize,
    required String creatorId,
  }) async {
    if (!_initialized) {
      throw StorageServiceNotInitializedException();
    }
    StorageBucket storageBucket = StorageBucket(
      id,
      creatorId: creatorId,
      maxAllowedSize: maxAllowedSize,
      parentFolderPath: parentFolderPath,
    );
    return storageBucket;
  }

  Future<List<StorageRefModel>> listChildren(
    String? bucketId,
    String ref,
  ) async {
    StorageBucket storageBucket = await _getTargetStorageBucket(bucketId, ref);
    String path = storageBucket.targetRefPath;
    var children = await _storageDatasource.getChildren(
      path,
      bucketId: storageBucket.id,
      ref: ref,
    );
    return children.map(
      (e) {
        var ref = storageBucket.getFileRef(e.path) ?? '';
        return StorageRefModel(
          bucketId: storageBucket.id,
          ref: ref,
          type: e.statSync().type == FileSystemEntityType.file
              ? 'file'
              : 'folder',
        );
      },
    ).toList();
  }

  Future<void> delete(StorageRefModel refModel, bool forceDelete) async {
    StorageBucket storageBucket =
        await _getTargetStorageBucket(refModel.bucketId, refModel.ref);
    String path = storageBucket.targetRefPath;
    return _storageDatasource.delete(
      path,
      refModel.type!,
      forceDelete,
    );
  }

  Future<StorageBucket> _getTargetStorageBucket(
    String? bucketId,
    String ref,
  ) async {
    StorageBucket? storageBucket =
        await _storageBuckets.getBucketById(bucketId, subRef: ref);
    if (storageBucket == null) {
      throw NoBucketException(bucketId);
    }
    return storageBucket;
  }
}
