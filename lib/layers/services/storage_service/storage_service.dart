import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/datasource/storage_datasource.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/models/storage_ref.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import '../../../features/storage_buckets/repo/bucket_controller_repo.dart';

class StorageService {
  final App app;
  bool _initialized = false;
  final StorageDatasource _storageDatasource = StorageDatasource();

  Future<void> init() async {
    await BucketsStore().init();
    _initialized = true;
  }

  Future<StorageBucket> createBucket(
    String name, {
    String? parentFolderPath,
    int? maxAllowedSize,
    BucketControllerRepo? controller,
    required String creatorId,
  }) async {
    if (!_initialized) {
      throw StorageServiceNotInitializedException();
    }
    StorageBucket storageBucket = StorageBucket(
      name,
      creatorId: creatorId,
      controller: controller,
      maxAllowedSize: maxAllowedSize,
      parentFolderPath: parentFolderPath,
    );
    return storageBucket;
  }

  StorageService(this.app);

  Future<List<StorageRefModel>> listChildren(
      String bucketName, String ref) async {
    String path = '';
    var children = await _storageDatasource.getChildren(
      path,
      bucketName: bucketName,
      ref: ref,
    );
    return children
        .map(
          (e) => StorageRefModel(
            bucketName: bucketName,
            ref: ref,
            type: e.statSync().type == FileSystemEntityType.file
                ? 'file'
                : 'folder',
          ),
        )
        .toList();
  }
}
