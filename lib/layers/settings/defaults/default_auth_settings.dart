import 'package:dart_verse/constants/collections.dart';

class DefaultAuthSettings {
  static const String collectionName = DBCollections.auth;
  static const bool allowDuplicateEmails = false;
  static const Duration authExpireAfter = Duration(days: 3 * 30);
  static const String activeTokensCollName = DBCollections.activeJWTs;
}
