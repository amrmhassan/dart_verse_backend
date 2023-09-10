// ignore_for_file: overridden_fields

import 'package:dart_verse_backend/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse_backend/features/auth_db_provider/repo/memory_db_repo_provider.dart';
import 'package:dart_verse_backend/layers/services/auth/controllers/jwt_controller.dart';
import 'package:dart_verse_backend/layers/services/auth/models/auth_model.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';

import '../../../../constants/model_fields.dart';
import '../../../../layers/settings/app/app.dart';

class MemoryDbAuthProvider extends AuthDbProvider
    implements MemoryDbRepoProvider {
  @override
  final App app;
  @override
  final DbService dbService;
  MemoryDbAuthProvider(this.app, this.dbService) : super(app, dbService);

  @override
  Future<String> createJwtAndSave(String id, String email) {
    JWTController jwtController = JWTController(app);
    return jwtController.createJwtAndSave(
      id: id,
      email: email,
    );
  }

  @override
  Future<AuthModel?> getUserByEmail(String email) async {
    var data = dbService.memoryDbController
        .collection(app.authSettings.collectionName)
        .getDocWhere(
          (element) => element[ModelFields.email] == email,
        )
        ?.getData();
    if (data == null) return null;
    try {
      return AuthModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveUserAuth(AuthModel authModel) async {
    try {
      dbService.memoryDbController
          .collection(app.authSettings.collectionName)
          .insertDoc(authModel.toJsonWith_Id());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      dbService.memoryDbController
          .collection(app.userDataSettings.collectionName)
          .insertDoc(userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  // @override
  // Future<void> saveJwt({required String id, required String jwt}) async {
  //   // i just want to add the jwt to the user collection
  //   var data = dbService.memoryDbController
  //       .collection(app.authSettings.activeJWTCollName)
  //       .getDocRefById(id)
  //       ?.getData();
  //   List<String> jwts = data?[ModelFields.activeTokens] ?? [];
  //   // checking if saved jwts list contains the new jwt to skip adding it
  //   if (jwts.any((element) => element == jwt)) {
  //     return;
  //   }
  //   jwts.add(jwt);
  //   dbService.memoryDbController
  //       .collection(app.authSettings.activeJWTCollName)
  //       .doc(id)
  //       .set({
  //     ModelFields.activeTokens: jwts,
  //   });
  // }

  // @override
  // Future<bool> checkIfJwtIsActive(String jwt, String id) async {
  //   var data = dbService.memoryDbController
  //       .collection(app.authSettings.activeJWTCollName)
  //       .getDocRefById(id)
  //       ?.getData();
  //   List<String> jwts = data?[ModelFields.activeTokens] ?? [];
  //   // checking if saved jwts list contains the new jwt to skip adding it
  //   if (jwts.any((element) => element == jwt)) {
  //     return true;
  //   }
  //   return false;
  // }

  @override
  Future<void> deleteAuthData(String id) {
    // TODO: implement deleteAuthData
    throw UnimplementedError();
  }

  @override
  Future<AuthModel?> getUserById(String id) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<void> verifyUser(String jwt) {
    // TODO: implement verifyUser
    throw UnimplementedError();
  }

  @override
  Future<String> createVerifyEmailToken(String email,
      {required Duration? allowNewJwtAfter,
      required Duration? verifyLinkExpiresAfter}) {
    // TODO: implement createVerifyEmailToken
    throw UnimplementedError();
  }

  @override
  Future<bool?> checkUserVerified(String userId) {
    // TODO: implement checkUserVerified
    throw UnimplementedError();
  }

  @override
  Future<void> changePassword(String email,
      {required String oldPassword, required String newPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUserData(String id) {
    // TODO: implement deleteUserData
    throw UnimplementedError();
  }

  @override
  Future<void> forgetPassword(String email) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> fullyDeleteUser(String id) {
    // TODO: implement fullyDeleteUser
    throw UnimplementedError();
  }

  @override
  Future<void> logout(String jwt) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> logoutFromAllDevices(String id) {
    // TODO: implement logoutFromAllDevices
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserData(String id, Map<String, dynamic> updateDoc) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIfJwtIsActive(String jwt, String id) {
    // TODO: implement checkIfJwtIsActive
    throw UnimplementedError();
  }
}
