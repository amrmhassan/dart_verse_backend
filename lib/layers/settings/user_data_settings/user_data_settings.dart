import 'package:dart_verse/constants/collections.dart';

class UserDataSettings {
  final String collectionName;
  const UserDataSettings({
    this.collectionName = DBCollections.users,
  });
}
