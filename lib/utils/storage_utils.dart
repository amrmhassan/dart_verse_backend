import 'dart:io';

import 'package:dart_verse/errors/models/storage_errors.dart';

class StorageUtils {
  static bool isFile(String path) {
    return File(path).existsSync();
  }

  static bool isDir(String path) {
    return Directory(path).existsSync();
  }

  static void deleteRef(
    String path, {
    required String bucketName,
    required String ref,
  }) {
    File file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
      return;
    }
    Directory directory = Directory(path);
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
      return;
    }
    throw RefNotFound(bucketName, ref);
  }
}
