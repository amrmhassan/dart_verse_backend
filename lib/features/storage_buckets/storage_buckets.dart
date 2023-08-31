import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';

List<StorageBucket> _defaultBucket = [
  StorageBucket('storage', creatorId: 'admin'),
];

class StorageBuckets {
  Future<StorageBucket?> getBucketById(String? id) async {
    if (id == null) return _defaultBucket.first;
    // StorageBucket? bucket = _repo.cast().firstWhere(
    //       (element) => element.name == name,
    //       orElse: () => null,
    //     );
    // if (bucket != null) return bucket;

    var bucketPath = BucketsStore.getBucketPath(id);
    if (bucketPath == null) return null;
    StorageBucket? storageBucket = StorageBucket.fromPath(bucketPath);
    if (storageBucket == null) return null;
    // _repo.add(storageBucket);
    return storageBucket;
  }
}
