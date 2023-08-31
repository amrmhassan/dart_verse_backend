import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_buckets/storage_buckets.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/datasource/storage_datasource.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/models/storage_ref.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import '../../../features/storage_buckets/repo/bucket_controller_repo.dart';

class StorageService {
  final App app;
  bool _initialized = false;
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
    BucketControllerRepo? controller,
    required String creatorId,
  }) async {
    if (!_initialized) {
      throw StorageServiceNotInitializedException();
    }
    StorageBucket storageBucket = StorageBucket(
      id,
      creatorId: creatorId,
      controller: controller,
      maxAllowedSize: maxAllowedSize,
      parentFolderPath: parentFolderPath,
    );
    return storageBucket;
  }

  StorageService(this.app);

  Future<List<StorageRefModel>> listChildren(
    String? bucketId,
    String ref,
  ) async {
    StorageBucket? storageBucket =
        await _storageBuckets.getBucketById(bucketId);
    if (storageBucket == null) {
      throw NoBucketException(bucketId);
    }

    String path = storageBucket.targetFolderPath;
    var children = await _storageDatasource.getChildren(
      path,
      bucketId: storageBucket.id,
      ref: ref,
    );
    return children
        .map(
          (e) => StorageRefModel(
            bucketId: bucketId,
            ref: ref,
            type: e.statSync().type == FileSystemEntityType.file
                ? 'file'
                : 'folder',
          ),
        )
        .toList();
  }
}
