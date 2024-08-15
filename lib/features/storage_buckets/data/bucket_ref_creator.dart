import 'package:dart_verse_backend_new/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend_new/utils/string_utils.dart';

extension BucketRefCreator on StorageBucketModel {
  ///? this will migrate from the requested bucket in the headers to <br>
  ///? another bucket reached from the ref, but the allowing rules will be applied from the referenced bucket <br>
  ///? but if there is no storage bucket from the ref, this will return the original bucket with it's rule <br>
  ///? and the ref will only be used as a sub dir inside the original bucket <br>
  ///? so that ref method must return the nearest bucket in the path from it's end <br>
  ///? like if the path is /{storage}/users/{amr}/images <br>
  ///? if this is the ref and the {} means this is a bucket then the amr bucket will be returned from this path <br>
  ///? so this must return a bucket
  ///? but not necessarily the current bucket

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

  Future<StorageBucketModel> ref(String? path) async {
    path ??= '';
    List<String> iterations = path.strip('/').split('/');
    StorageBucketModel nearestSubBucket = this;
    subRef = path;
    String collector = '';
    int nearestBucketIndex = -1;
    // Iterate through the path components
    for (int i = 0; i < iterations.length; i++) {
      String iteration = iterations[i];
      collector = '$collector$iteration/';
      StorageBucketModel? currentBucket =
          await StorageBucketModel.fromPath(collector);
      // StorageBucket? currentBucket = collector == 'stores/store1/'
      //     ? StorageBucket(
      //         'store1',
      //         creatorId: 'store1',
      //         parentFolderPath: 'Buckets/storage/stores',
      //       )
      //     : null;

      if (currentBucket != null) {
        // If a sub bucket is found, update the nearest sub bucket
        nearestSubBucket = currentBucket;
        nearestBucketIndex = i;

        // If it's the last iteration, set the subDirRef
        if (i == iterations.length - 1) {
          nearestSubBucket.subRef = path
              .substring(
                path.indexOf(iteration) + iteration.length,
              )
              .strip('/');
        }
      } else {
        if (i == iterations.length - 1) {
          if (nearestBucketIndex == -1) {
            nearestSubBucket.subRef = collector;
          } else {
            nearestSubBucket.subRef = collector
                .strip('/')
                .split('/')
                .sublist(nearestBucketIndex + 1)
                .join('/');
          }
        }
        continue; // No more buckets found, break the loop
      }
    }

    return nearestSubBucket;
  }
}
