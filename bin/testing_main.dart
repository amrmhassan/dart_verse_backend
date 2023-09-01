import 'package:dart_verse_backend/dart_verse.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/storage_permission_source.dart';

void main(List<String> args) async {
  await DartVerse.initializeApp();
  StoragePermissionSource source = StoragePermissionSource('storage');
  DateTime start = DateTime.now();
  var bucketBox = await source.bucketBox();
  var refBox = await source.refBox();
  DateTime end = DateTime.now();
  print(end.difference(start).inMicroseconds / 1000);
}
