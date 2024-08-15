import 'package:dart_verse_backend_new/layers/services/storage_service/utils/buckets_store.dart';

class DartVerse {
  static Future<void> initializeApp() async {
    await BucketsStore().init();
  }
}
