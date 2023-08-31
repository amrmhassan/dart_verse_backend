import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/layers/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';

import '../storage_buckets/repo/bucket_controller_repo.dart';

class StorageService {
  bool _initialized = false;

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

  StorageService();
}
