import 'package:dart_verse_backend/dart_verse.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';

void main(List<String> args) async {
  await DartVerse.initializeApp();
  var bucket = StorageBucket('storage');
  await bucket.init();
  // await bucket.permissionsController.addBUserPermission('read', 'userId1');
  bucket.permissionChecker.defaultValue = false;

  var allowed = await bucket.permissionChecker
      .userAllowed(permissionName: 'write', userId: 'userId2');

  print(allowed);
}
