import 'package:dart_verse_backend/dart_verse.dart';
import 'package:dart_verse_backend/features/storage_permissions/data/datasources/storage_permission_source.dart';

void main(List<String> args) async {
  await DartVerse.initializeApp();
  SBBoxes sbBoxes = SBBoxes('storage');
}
