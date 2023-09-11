import 'package:dart_verse_backend/features/storage_buckets/data/bucket_ref_creator.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';

StorageBucket _defaultStorageBucket(String? subDirRef) {
  return StorageBucket(
    'storage',
    creatorId: 'admin',
    subRef: subDirRef,
  );
}

class StorageBuckets {
  static StorageBucket get defaultBucket => _defaultStorageBucket(null);
  Future<StorageBucket?> getBucketById(
    String? id, {
    String? subRef,
  }) async {
    if (id == null) return _defaultStorageBucket(subRef);
    var bucketPath = BucketsStore.getBucketPath(id);
    if (bucketPath == null) return null;
    StorageBucket? storageBucket = await StorageBucket.fromPath(bucketPath);
    if (storageBucket == null) return null;
    // _repo.add(storageBucket);

    StorageBucket actualBucket = await storageBucket.ref(subRef);
    return actualBucket;
  }
}
