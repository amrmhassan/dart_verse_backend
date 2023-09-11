import 'package:dart_verse_backend/features/storage_buckets/data/bucket_ref_creator.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';

StorageBucketModel _defaultStorageBucket(String? subDirRef) {
  return StorageBucketModel(
    'storage',
    creatorId: 'admin',
    subRef: subDirRef,
  );
}

class StorageBuckets {
  static StorageBucketModel get defaultBucket => _defaultStorageBucket(null);
  Future<StorageBucketModel?> getBucketById(
    String? id, {
    String? subRef,
  }) async {
    if (id == null) return _defaultStorageBucket(subRef);
    var bucketPath = BucketsStore.getBucketPath(id);
    if (bucketPath == null) return null;
    StorageBucketModel? storageBucket =
        await StorageBucketModel.fromPath(bucketPath);
    if (storageBucket == null) return null;
    // _repo.add(storageBucket);

    StorageBucketModel actualBucket = await storageBucket.ref(subRef);
    return actualBucket;
  }
}
