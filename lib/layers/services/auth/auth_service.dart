import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse_backend/constants/reserved_keys.dart';
import 'package:dart_verse_backend/errors/models/auth_errors.dart';
import 'package:dart_verse_backend/errors/models/database_errors.dart';
import 'package:dart_verse_backend/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse_backend/layers/services/auth/models/jwt_payload.dart';
import 'package:dart_verse_backend/layers/services/service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'controllers/secure_password.dart';
import 'models/auth_model.dart';

class AuthService implements DVService {
  final AuthDbProvider authDbProvider;

  AuthService(
    this.authDbProvider,
  );

  /// this will return a jwt for the user to use to sign in again without the need of the email and password again
  Future<String> registerUser({
    required String email,
    required String password,
    Map<String, dynamic> userData = const {},
    String? customUserID,
  }) async {
    //! i want to add the functionality of reverting everything if an error occurred
    String id = customUserID ?? ObjectId().toHexString();

    String passwordHash = SecurePassword(password).getPasswordHash();

    // first check if email already exists
    AuthModel? savedModel = await authDbProvider.getUserByEmail(email);
    if (savedModel != null) {
      throw DuplicateEmailException();
    }
    AuthModel authModel = AuthModel(
      id: id,
      email: email,
      passwordHash: passwordHash,
    );
    // creating the jwt
    bool authModelSaved = await authDbProvider.saveUserAuth(authModel);

    if (!authModelSaved) {
      throw DBWriteException('failed to register user');
    }
    // saving user data
    userData[DBRKeys.id] = authModel.id;
    var userDataSaved = await authDbProvider.saveUserData(userData);
    if (!userDataSaved) {
      throw DBWriteException('failed to save user data');
    }

    String jwtToken =
        await authDbProvider.createJwtAndSave(authModel.id, email);

    return jwtToken;
  }

  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    AuthModel? savedModel = await authDbProvider.getUserByEmail(email);

    if (savedModel == null) {
      throw NoUserRegisteredException();
    }
    bool rightPassword =
        SecurePassword(password).checkPassword(savedModel.passwordHash);
    if (!rightPassword) {
      throw InvalidPassword();
    }

    // create and send the new jwt for the user
    String jwtToken =
        await authDbProvider.createJwtAndSave(savedModel.id, email);

    // get the user data to return it to the

    return jwtToken;
  }

  /// if the jwt is valid and allowed then it will return user id else null
  Future<String?> loginWithJWT(String jwt) async {
    // verify the jwt isn't manipulated
    var res = JWT.tryVerify(jwt, authDbProvider.app.authSettings.jwtSecretKey);
    if (res == null) {
      return null;
    }
    // get the data from the jwt
    JWTPayloadModel model = JWTPayloadModel.fromJson(res.payload);

    // check for the jwt in the allowed jwt tokens and active
    bool jwtIsActive = await authDbProvider.checkIfJwtIsActive(model);
    if (!jwtIsActive) {
      throw PasswordChangedException();
    }
    // check for the user id if it is a valid user
    AuthModel? authModel = await authDbProvider.getUserByEmail(model.email);
    if (authModel == null) {
      return null;
    }
    // then allow the user to continue
    return authModel.id;
  }

  /// delete auth user data with the jwt data
  Future<void> deleteAuthData(String userId) async {
    return authDbProvider.deleteAuthData(userId);
  }

  Future<void> markUserVerified(String jwt) {
    return authDbProvider.verifyUser(jwt);
  }

  Future<String> createVerifyEmailToken(
    String email, {
    required Duration? allowNewJwtAfter,
    required Duration? verifyLinkExpiresAfter,
  }) async {
    return authDbProvider.createVerifyEmailToken(
      email,
      allowNewJwtAfter: allowNewJwtAfter,
      verifyLinkExpiresAfter: verifyLinkExpiresAfter,
    );
  }

  Future<bool?> checkUserVerified(String userId) {
    return authDbProvider.checkUserVerified(userId);
  }

  Future<void> changePassword(
    String id, {
    required String oldPassword,
    required String newPassword,
  }) {
    return authDbProvider.changePassword(id,
        oldPassword: oldPassword, newPassword: newPassword);
  }

  // this must run with user email not user id
  Future<void> forgetPassword(String email) {
    return authDbProvider.forgetPassword(email);
  }

  // can run with user id
  Future<void> deleteUserData(String id) {
    return authDbProvider.deleteUserData(id);
  }

  // can run with user id
  Future<void> fullyDeleteUser(String id) {
    return authDbProvider.fullyDeleteUser(id);
  }

  Future<void> logout(String jwt) {
    return authDbProvider.logout(jwt);
  }

  // can run with user id
  Future<void> logoutFromAllDevices(String id) {
    return authDbProvider.logoutFromAllDevices(id);
  }

  // can run with user id
  Future<void> updateUserData(String id, Map<String, dynamic> updateDoc) {
    return authDbProvider.updateUserData(id, updateDoc);
  }
}
