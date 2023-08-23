// ignore_for_file: overridden_fields

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/constants/reserved_keys.dart';
import 'package:dart_verse/errors/models/email_verification_error.dart';
import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/features/auth_db_provider/repo/mongo_db_repo_provider.dart';
import 'package:dart_verse/layers/services/auth/controllers/jwt_controller.dart';
import 'package:dart_verse/layers/services/auth/controllers/secure_password.dart';
import 'package:dart_verse/layers/services/auth/models/auth_model.dart';
import 'package:dart_verse/layers/services/db_manager/db_service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../../errors/models/auth_errors.dart';
import '../../../../layers/settings/app/app.dart';

class MongoDbAuthProvider extends AuthDbProvider
    implements MongoDbRepoProvider {
  @override
  final App app;
  @override
  final DbService dbService;
  MongoDbAuthProvider(this.app, this.dbService) : super(app, dbService);

  @override
  Future<String> createJwtAndSave(String id, String email) {
    JWTController jwtController = JWTController(app);
    return jwtController.createJwtAndSave(
      id: id,
      email: email,
      saveJwt: saveJwt,
    );
  }

  @override
  Future<AuthModel?> getUserByEmail(String email) async {
    var data = await dbService.mongoDbController
        .collection(app.authSettings.collectionName)
        .findOne(where.eq(ModelFields.email, email));

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
      var docRef = await dbService.mongoDbController
          .collection(app.authSettings.collectionName)
          .insertOne(authModel.toJsonWith_Id());

      bool failure = docRef.failure;
      if (failure) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      var docRef = await dbService.mongoDbController
          .collection(app.userDataSettings.collectionName)
          .insertOne(userData);
      bool failure = docRef.failure;
      if (failure) {
        return false;
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveJwt({required String id, required String jwt}) async {
    //? first checks for saved jwts
    var collection = dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName);

    // Check if the active JWTs count has exceeded the limit of 5
    var countQuery =
        where.eq(DBRKeys.id, id).fields([ModelFields.activeTokens]);
    var countResult = await collection.findOne(countQuery);

    var fetchedTokens = (countResult?[ModelFields.activeTokens] as List?) ?? [];
    int activeTokensLength = 0;
    for (var token in fetchedTokens) {
      try {
        JWT.verify(token, app.authSettings.jwtSecretKey);
        activeTokensLength++;
      } catch (e) {
        continue;
      }
    }
    if (activeTokensLength >= app.authSettings.maximumActiveJwts) {
      throw LoginExceedException();
    }
    // i just want to add the jwt to the user collection
    // var data = await dbService.mongoDbController
    //     //! here instead of getting the data from the remote db
    //     //! just make modification query to the db to add the new jwt to the list
    //     .collection(app.authSettings.activeJWTCollName)
    //     .findOne(where.eq(DBRKeys.id, id));

    // List<String> jwts =
    //     ((data?[ModelFields.activeTokens] ?? []) as List).cast();
    // // checking if saved jwts list contains the new jwt to skip adding it
    // if (jwts.any((element) => element == jwt)) {
    //   return;
    // }

    var pushQuery = where.eq(DBRKeys.id, id);
    var pushUpdate = modify.push(ModelFields.activeTokens, jwt);

    await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .update(pushQuery, pushUpdate, upsert: true);

    // jwts.add(jwt);
    // await dbService.mongoDbController
    //     .collection(app.authSettings.activeJWTCollName)
    //     .doc(id)
    //     .set({
    //   ModelFields.activeTokens: jwts,
    // });
  }

  @override
  Future<bool> checkIfJwtIsActive(String jwt, String id) async {
    var data = await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .findOne(where.eq(DBRKeys.id, id));

    List<String> jwts =
        ((data?[ModelFields.activeTokens] ?? []) as List).cast();
    // checking if saved jwts list contains the new jwt to skip adding it
    if (jwts.any((element) => element == jwt)) {
      return true;
    }
    return false;
  }

  @override
  Future<void> deleteAuthData(String id) async {
    await logoutFromAllDevices(id);
    var userAuthRes = await dbService.mongoDbController
        .collection(app.authSettings.collectionName)
        .doc(id)
        .delete();
    if (userAuthRes.failure) {
      throw Exception('cant delete user auth data for the user');
    }
  }

  @override
  Future<AuthModel?> getUserById(String id) async {
    var data = await dbService.mongoDbController
        .collection(app.authSettings.collectionName)
        .findOne(where.eq(DBRKeys.id, id));

    if (data == null) return null;
    try {
      return AuthModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> verifyUser(String jwt) async {
    //! here check if the verification jwt is saved on the db or not
    //! make a temp collection for users auth data like jwt verification
    //! or just save in the auth data collection

    // in here i should update the user from the database and make him verified
    var secretKey = app.authSettings.jwtSecretKey;
    var res = JWT.tryVerify(jwt, secretKey);
    if (res == null) {
      throw JwtEmailVerificationExpired();
    }
    var payload = res.payload;
    var id = payload[ModelFields.id];
    if (id is! String) {
      throw UserNotFoundToVerify();
    }

    var collection =
        dbService.mongoDbController.collection(app.authSettings.collectionName);
    //? first make sure that the saved jwt for the user is write
    var authData = await collection.doc(id).getData();
    if (authData == null) {
      throw FailedToVerifyException(1);
    }
    var savedJWT = authData[DbFields.verificationJWT];
    if (savedJWT == null) {
      throw FailedToVerifyException(4);
    }
    if (jwt != savedJWT) {
      throw FailedToVerifyException(5);
    }

    //? then delete the verification jwt form the auth data for the user
    var delete = modify.unset(DbFields.verificationJWT);
    var selector = where.eq(DBRKeys.id, id);
    var edit = await collection.updateOne(selector, delete);
    if (edit.failure) {
      throw FailedToVerifyException(2);
    }
    //? then mark the user as verified
    var writeRes = await collection.doc(id).update({DbFields.verified: true});
    if (writeRes.failure) {
      throw FailedToVerifyException(3);
    }
  }

  @override
  Future<String> createVerifyEmailToken(
    String email, {
    required Duration? allowNewJwtAfter,
    required Duration? verifyLinkExpiresAfter,
  }) async {
    var collection =
        dbService.mongoDbController.collection(app.authSettings.collectionName);
    //? get the saved email verification and check if it exceeded the amount of a new verification
    var authModel =
        await collection.findOne(where.eq(ModelFields.email, email));
    // var authModel = await collection.doc(userId).getData();
    if (authModel == null) {
      throw FailedToStartVerificationException('no user found');
    }

    if (allowNewJwtAfter != null) {
      //! check if the user is already verified
      bool? verified = authModel[DbFields.verified];
      if (verified == true) {
        throw UserIsAlreadyVerifiedException();
      }
      var savedJwt = authModel[DbFields.verificationJWT];
      if (savedJwt != null) {
        // here check that the saved jwt is old enough to exceed the allowable amount of time
        var jwt = JWT.tryVerify(savedJwt, app.authSettings.jwtSecretKey);
        if (jwt != null) {
          DateTime createdAt =
              DateTime.fromMillisecondsSinceEpoch(jwt.payload['iat'] * 1000);
          DateTime now = DateTime.now();
          Duration diff = now.difference(createdAt);
          if (diff.inMicroseconds < allowNewJwtAfter.inMicroseconds) {
            // here the user is asking for a new token before the time has ended
            throw EarlyVerificationAskingException(
                (allowNewJwtAfter.inSeconds - diff.inSeconds));
          }
        }
      }
    }
    //? check if the user isn't already verified
    //? if exceed or no jwt saved just create the new one
    // here just get the auth model for the user to make sure that the user exists
    String userId = authModel[ModelFields.id];

    var payload = {
      ModelFields.id: userId,
      ModelFields.email: authModel[ModelFields.email],
    };
    var jwt = JWT(payload);
    String jwtString = jwt.sign(
      app.authSettings.jwtSecretKey,
      algorithm: app.authSettings.jwtAlgorithm,
      expiresIn: verifyLinkExpiresAfter,
    );
    //! just save it to the db auth model before returning
    var res = await collection
        .doc(userId)
        .update({DbFields.verificationJWT: jwtString});
    if (res.failure) {
      throw FailedToStartVerificationException('unknown db write failure');
    }

    return jwtString;
  }

  @override
  Future<bool?> checkUserVerified(String userId) async {
    var collection =
        dbService.mongoDbController.collection(app.authSettings.collectionName);
    var doc = await collection.doc(userId).getData();
    if (doc == null) {
      return null;
    }
    var res = doc[DbFields.verified] == true;
    return res;
  }

  @override
  Future<void> changePassword(
    String email, {
    required String oldPassword,
    required String newPassword,

    /// this will prevent others from using the same jwt to log in after the password gets changed
    bool logoutFromAllDevices = true,
  }) async {
    //? if old password is the same as new password
    if (oldPassword == newPassword) {
      throw Exception('oldPassword must be different from newPassword');
    }
    //? checking for the user password if it's right
    AuthModel? authModel = await getUserByEmail(email);
    if (authModel == null) {
      throw NoUserRegisteredException();
    }
    bool rightPassword =
        SecurePassword(oldPassword).checkPassword(authModel.passwordHash);
    if (!rightPassword) {
      throw InvalidPassword();
    }
    // if reached here this means that the user email and password are right
    // the user doesn't need to be logged in to do this

    //? checking if i need to log out from all other devices
    if (logoutFromAllDevices) {
      var activeJWTS = dbService.mongoDbController
          .collection(app.authSettings.activeJWTCollName);
      var res = await activeJWTS.doc(authModel.id).delete();
      if (res.failure) {
        throw Exception(
            'can\'t log out from other devices, password didn\'t change');
      }
    }
    //? changing the password
    String passwordHash = SecurePassword(newPassword).getPasswordHash();
    var collection =
        dbService.mongoDbController.collection(app.authSettings.collectionName);
    var selector = where.eq(ModelFields.email, email);

    var updateQuery = modify.set(ModelFields.passwordHash, passwordHash);
    var res = await collection.updateOne(selector, updateQuery);
    if (res.failure) {
      throw Exception('can\'t edit the password');
    }
  }

  @override
  Future<void> deleteUserData(String id) async {
    var userDataCollection = dbService.mongoDbController
        .collection(app.userDataSettings.collectionName);
    var res = await userDataCollection.doc(id).delete();
    if (res.failure) {
      throw Exception('can\'t delete user data');
    }
  }

  @override
  Future<void> forgetPassword(String email) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  Future<void> fullyDeleteUser(String id) async {
    var authCollection =
        dbService.mongoDbController.collection(app.authSettings.collectionName);
    var authData = await authCollection.doc(id).getData();
    String? email = authData?[ModelFields.email];
    if (email == null) {
      throw Exception('can\'t find the user auth info to delete');
    }
    // delete user data
    await deleteUserData(id);
    // logout from all devices
    await logoutFromAllDevices(email);
    // delete user auth data
    await deleteAuthData(id);
  }

  @override
  Future<void> logout(String jwt) async {
    var res = JWT.tryVerify(jwt, app.authSettings.jwtSecretKey);
    if (res == null) {
      throw ProvidedJwtNotValid(2);
    }
    // String id = res.payload[ModelFields.id];
    // var activeJWTs = dbService.mongoDbController
    //     .collection(app.authSettings.activeJWTCollName);
    // var selector = where.eq(DbFields.id, id);
    // var update = modify;
    //! here search how to delete a value from a list in the mongo db(to delete the current jwt only from the activeJWTs)
    throw UnimplementedError();
  }

  @override
  Future<void> logoutFromAllDevices(String id) async {
    var activeJwts = dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName);
    var res = await activeJwts.doc(id).delete();

    if (res.failure) {
      throw Exception('can\'t logout from all devices');
    }
  }

  @override
  Future<void> updateUserData(String id, Map<String, dynamic> updateDoc) async {
    var userData = dbService.mongoDbController
        .collection(app.userDataSettings.collectionName);
    var res = await userData.doc(id).update(
          updateDoc,
          upsert: true,
        );
    if (res.failure) {
      throw Exception('can\'t update user data');
    }
  }
}
