import 'package:dart_verse_backend/layers/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/utils/string_utils.dart';

extension BucketRefCreator on StorageBucket {
  // main*/stores/store1*/images
  // main*/data/images

  // so the main is bucket
  // the store1 is a bucket
  // no other buckets, the remaining folders are just folders

  //1  so if the bucket is (main)
  //a -- path is main/data/images/image1.jpg
  // -- the bucket must be main and the subDirRef will be data/images

  //b -- path is main/stores/store1/images/image1.jpg
  // -- the bucket must be store1 and the subDirRef will be images
  StorageBucket ref(String path) {
    List<String> iterations = path.strip('/').split('/');
    StorageBucket? nearestSubBucket = this;
    subDirRef = path;
    String collector = '';

    // Iterate through the path components
    for (int i = 0; i < iterations.length; i++) {
      String iteration = iterations[i];
      collector = '$collector$iteration/';
      StorageBucket? currentBucket = StorageBucket.fromPath(collector);

      if (currentBucket != null) {
        // If a sub bucket is found, update the nearest sub bucket
        nearestSubBucket = currentBucket;

        // If it's the last iteration, set the subDirRef
        if (i == iterations.length - 1) {
          nearestSubBucket.subDirRef = path
              .substring(
                path.indexOf(iteration) + iteration.length,
              )
              .strip('/');
        }
      } else {
        continue; // No more buckets found, break the loop
      }
    }

    return nearestSubBucket!;
  }
}
