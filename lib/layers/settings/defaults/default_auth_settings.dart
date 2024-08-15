import 'package:dart_verse_backend_new/constants/collections.dart';

class DefaultAuthSettings {
  static const String collectionName = DBCollections.auth;
  static const bool allowDuplicateEmails = false;
  static const Duration authExpireAfter = Duration(days: 3 * 30);
  static const String authUpdatesCollName = DBCollections.authUpdatesCollName;
}
