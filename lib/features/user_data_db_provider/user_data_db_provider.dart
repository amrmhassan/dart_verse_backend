import 'package:dart_verse_backend_new/layers/services/db_manager/db_service.dart';

import '../../layers/settings/app/app.dart';

abstract class UserDataDbProvider {
  final App app;
  final DbService dbService;
  const UserDataDbProvider(this.app, this.dbService);

  Future<Map<String, dynamic>?> updateUserData(
    String userId,
    Map<String, dynamic> updateDoc,
  );

  Future<Map<String, dynamic>?> deleteUserData(
    String userId,
    bool deleteAuthData,
    Future<void> Function() deleteAuthDataMethod,
  );

  Future<Map<String, dynamic>?> setUserData(
    String userId,
    Map<String, dynamic> newDoc,
  );
  Future<Map<String, dynamic>?> getUserData(String userId);
  Future<Map<String, dynamic>?> getUserDataByEmail(String email);
}
