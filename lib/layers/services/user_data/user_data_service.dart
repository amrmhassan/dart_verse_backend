import 'package:dart_verse_backend/errors/models/auth_errors.dart';
import 'package:dart_verse_backend/errors/models/user_data_errors.dart';
import 'package:dart_verse_backend/features/auth_db_provider/impl/memory_db_auth_provider/memory_db_auth_provider.dart';
import 'package:dart_verse_backend/features/auth_db_provider/impl/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse_backend/features/user_data_db_provider/memory_db_user_data_provider/memory_db_user_data_provider.dart';
import 'package:dart_verse_backend/features/user_data_db_provider/mongo_db_user_data_provider/mongo_db_user_data_provider.dart';
import 'package:dart_verse_backend/features/user_data_db_provider/user_data_db_provider.dart';
import 'package:dart_verse_backend/layers/services/auth/auth_service.dart';
import 'package:dart_verse_backend/layers/services/auth/models/auth_model.dart';
import 'package:dart_verse_backend/layers/services/service.dart';

class UserDataService implements DVService {
  final AuthService _authService;
  UserDataDbProvider? _userDataDbProvider;

  UserDataService(this._authService) {
    if (_authService.authDbProvider is MemoryDbAuthProvider) {
      _userDataDbProvider = MemoryDbUserDataProvider(
        _authService.authDbProvider.app,
        _authService.authDbProvider.dbService,
      );
    } else if (_authService.authDbProvider is MongoDbAuthProvider) {
      _userDataDbProvider = MongoDbUserDataProvider(
        _authService.authDbProvider.app,
        _authService.authDbProvider.dbService,
      );
    } else {
      throw UserDataServiceDependOnAuthServiceException();
    }
  }

  UserDataDbProvider get userDataDbProvider {
    if (_userDataDbProvider == null) {
      throw UserDataServiceDependOnAuthServiceException();
    }
    return _userDataDbProvider!;
  }

  /// update user data with the updateDoc and returns the new updated user data map
  /// will override only the values presented in the update Doc and leave all other properties as they are `(the _id can't be changed and can't be deleted)`
  /// if the _id isn't presented in the newDoc no worries it will be the same
  /// if the user data doesn't exist it will create a new document with the provided user data
  Future<Map<String, dynamic>?> updateUserData(
    String userId,
    Map<String, dynamic> updateDoc,
  ) {
    return userDataDbProvider.updateUserData(userId, updateDoc);
  }

  /// delete user data without the auth data(user can still login) if deleteAuthData isn't changed
  Future<Map<String, dynamic>?> deleteUserData(
    String userId, {
    bool deleteAuthData = false,
  }) {
    return userDataDbProvider.deleteUserData(
      userId,
      deleteAuthData,
      () async {
        await _authService.deleteAuthData(userId);
      },
    );
  }

  /// sets the current user data to the newDoc
  /// remove the old document and add the newDoc instead `(the _id can't be changed and can't be deleted)`
  /// if the _id isn't presented in the newDoc no worries it will be the same
  /// if the user data doesn't exist it will create a new document with the provided user data
  Future<Map<String, dynamic>?> setUserData(
    String userId,
    Map<String, dynamic> newDoc, {
    /// this will make sure that the auth data for user exist first before setting the
    /// user data
    bool authDataMustExist = true,
  }) async {
    if (authDataMustExist) {
      AuthModel? authModel =
          await _authService.authDbProvider.getUserById(userId);
      if (authModel == null) {
        throw NoUserRegisteredException();
      }
    }
    return userDataDbProvider.setUserData(userId, newDoc);
  }

  Future<Map<String, dynamic>?> getUserData(
    String userId, {
    /// this will make sure that the auth data for user exist first before setting the
    /// user data
    bool authDataMustExist = true,
  }) async {
    if (authDataMustExist) {
      AuthModel? authModel =
          await _authService.authDbProvider.getUserById(userId);
      if (authModel == null) {
        throw NoUserRegisteredException();
      }
    }
    return userDataDbProvider.getUserData(userId);
  }

  Future<Map<String, dynamic>?> getUserDataByEmail(
    String email, {
    /// this will make sure that the auth data for user exist first before setting the
    /// user data
    bool authDataMustExist = true,
  }) async {
    if (authDataMustExist) {
      AuthModel? authModel =
          await _authService.authDbProvider.getUserByEmail(email);
      if (authModel == null) {
        throw NoUserRegisteredException();
      }
    }
    return userDataDbProvider.getUserDataByEmail(email);
  }
}
