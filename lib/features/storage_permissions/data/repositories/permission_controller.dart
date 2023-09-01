import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/storage_permission_source.dart';
import 'package:hive/hive.dart';

class StoragePermissionController {
  late SBBoxes _sbBoxes;

  final StorageBucket _storageBucket;
  Box? _bucketBox;
  Box? _refBox;

  StoragePermissionController(this._storageBucket) {
    _sbBoxes = SBBoxes(_storageBucket.id);
  }
  //? getting boxes
  Future<Box> get bucketBox async {
    if (_bucketBox != null) {
      return _bucketBox!;
    }
    var box = await _sbBoxes.bucketBox();
    _bucketBox = box;
    return box;
  }

  Future<Box> get refBox async {
    if (_refBox != null) {
      return _refBox!;
    }
    var box = await _sbBoxes.refBox();
    _refBox = box;
    return box;
  }
  //? handling permissions
}
