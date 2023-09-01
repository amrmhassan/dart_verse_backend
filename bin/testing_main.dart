import 'package:dart_verse_backend/dart_verse.dart';
import 'package:dart_verse_backend/features/storage_buckets/models/storage_bucket_model.dart';

void main(List<String> args) async {
  await DartVerse.initializeApp();
  var bucket = StorageBucket('storage');
  await bucket.init();
}
