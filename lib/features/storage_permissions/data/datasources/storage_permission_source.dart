import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_buckets/storage_buckets.dart';

class StoragePermissionSource {
  final StorageBuckets storageBuckets;

  const StoragePermissionSource(this.storageBuckets);
  // i will first get the ref for that storage
  void handle(String bucketId, String ref, String permissionName) async {
    StorageBucket? bucket =
        await storageBuckets.getBucketById(bucketId, subRef: ref);
    if (bucket == null) {
      //! throw an error
      throw Exception();
    }
    // here handle the permission
  }
}
