import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/datasource/custom_isolate.dart';

class StorageDatasource {
  Future<List<FileSystemEntity>> getChildren(
    String path, {
    required String bucketId,
    required String ref,
  }) async {
    Directory directory = Directory(path);
    bool exist = directory.existsSync();
    if (!exist) {
      throw RefNotFound(bucketId, ref, 'or this ref is not a directory');
    }
    var res = await customCompute(_listIsolate, directory);
    return res;
  }

  Future<List<FileSystemEntity>> _listIsolate(Directory directory) async {
    return directory.listSync();
  }
}
