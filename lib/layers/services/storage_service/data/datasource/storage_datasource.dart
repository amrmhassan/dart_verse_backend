import 'dart:io';

import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/layers/services/storage_service/data/datasource/custom_isolate.dart';

class EntityType {
  static const String file = 'file';
  static const String folder = 'folder';
}

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

  //
  Future<void> delete(String path, String type, bool force) async {
    await customCompute((message) => _deleteIsolate(path, type, force), null);
  }

  Future<void> _deleteIsolate(
    String path,
    String type,
    bool force,
  ) async {
    if (type == EntityType.file) {
      File file = File(path);
      if (!file.existsSync()) {
        throw FileNotFound(
            'please provide the right entity type or check the required path');
      } else {
        if (force) {
          file.deleteSync(recursive: true);
        } else {
          file.deleteSync();
        }
      }
    } else if (type == EntityType.folder) {
      Directory directory = Directory(path);
      if (!directory.existsSync()) {
        throw FolderNotFound(
            'please provide the right entity type or check the required path');
      } else {
        if (force) {
          directory.deleteSync(recursive: true);
        } else {
          directory.deleteSync();
        }
      }
    }
  }
}
