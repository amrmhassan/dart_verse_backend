import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';

StorageBucket _defaultStorageBucket(String? subDirRef) {
  return StorageBucket(
    'storage',
    creatorId: 'admin',
    subDirRef: subDirRef,
  );
}

class StorageBuckets {
  Future<StorageBucket?> getBucketById(
    String? id, {
    String? subDirRef,
  }) async {
    if (id == null) return _defaultStorageBucket(subDirRef);
    // StorageBucket? bucket = _repo.cast().firstWhere(
    //       (element) => element.name == name,
    //       orElse: () => null,
    //     );
    // if (bucket != null) return bucket;

    var bucketPath = BucketsStore.getBucketPath(id);
    if (bucketPath == null) return null;
    StorageBucket? storageBucket =
        StorageBucket.fromPath(bucketPath, subDirRef: subDirRef);
    if (storageBucket == null) return null;
    // _repo.add(storageBucket);
    return storageBucket;
  }
}
