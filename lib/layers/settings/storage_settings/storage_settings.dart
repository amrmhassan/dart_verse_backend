// import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';

// import '../../../errors/models/storage_errors.dart';

class StorageSettings {
  /// these buckets are places where you will save files and folders
  /// your whole app can run on just one bucket and it will be the default bucket
  /// or you can add multiple buckets and specify which bucket you want to save or operate files through
  /// each bucket name must be unique

  // void _checkDuplicateBuckets() {
  //   List<String> names = [];
  //   List<String> paths = [];
  //   for (var bucket in storageBuckets) {
  //     if (paths.contains(bucket.folderPath)) {
  //       throw DuplicateBucketPathException(bucket.folderPath);
  //     }
  //     if (names.contains(bucket.id)) {
  //       throw DuplicateBucketNameException(bucket.id);
  //     }

  //     names.add(bucket.id);
  //     paths.add(bucket.folderPath);
  //   }
  // }

  // StorageBucket? getBucket([String? id]) {
  //   // if name is null this it will return the first bucket it encounters
  //   if (id == null) {
  //     return storageBuckets.first;
  //   }
  //   return storageBuckets.cast().firstWhere(
  //         (element) => element.name == id,
  //         orElse: () => null,
  //       );
  // }
}
