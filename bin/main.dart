// you can apply acm permissions with sql db local file in the bucket itself
// instead of making your own custom one

// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse_backend/dart_verse.dart';
import 'package:dart_verse_backend/features/auth_db_provider/impl/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/auth_server.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/impl/default_auth_server_settings.dart';
import 'package:dart_verse_backend/layers/service_server/db_server/db_server.dart';
import 'package:dart_verse_backend/layers/service_server/db_server/impl/default_db_server_settings.dart';
import 'package:dart_verse_backend/layers/services/auth/auth_service.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend/layers/services/storage_service/storage_service.dart';
import 'package:dart_verse_backend/layers/services/web_server/server_service.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse_backend/layers/settings/db_settings/db_settings.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/server_settings.dart';
import 'package:dart_verse_backend/layers/settings/storage_settings/storage_settings.dart';
import 'package:dart_verse_backend/layers/settings/user_data_settings/user_data_settings.dart';

import 'constants.dart';

void main(List<String> arguments) async {
  await DartVerse.initializeApp();
  MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);

  DBSettings dbSettings = DBSettings(mongoDBProvider: mongoDBProvider);
  UserDataSettings userDataSettings = UserDataSettings();
  AuthSettings authSettings = AuthSettings(
    jwtSecretKey: SecretKey('jwtSecretKey'),
    allowedAppsIds: ['amrhassan'],
  );
  ServerSettings serverSettings = ServerSettings(InternetAddress.anyIPv4, 3000);

  StorageSettings storageSettings = StorageSettings();

  App app = App(
    dbSettings: dbSettings,
    authSettings: authSettings,
    userDataSettings: userDataSettings,
    serverSettings: serverSettings,
    storageSettings: storageSettings,
    backendHost: 'http://localhost:3000',
  );

  DbService dbService = DbService(app);
  AuthService authService = AuthService(
    MongoDbAuthProvider(app, dbService),
  );
  await dbService.connectToDb();
  var authServer = AuthServer(app, DefaultAuthServerSettings(authService));
  var dbServer = DBServer(app, DefaultDbServerSettings(dbService));

  ServerService serverService = ServerService(
    app,
    authServer: authServer,
    dbServer: dbServer,
  );

  var storageService = StorageService(app, serverService);
  await storageService.init();
  await serverService.runServer();
}

// //? visit this google oauth playground https://developers.google.com/oauthplayground to get more info about how to access google services for a google account
// //? and this link for google apis assess and manage https://developers.google.com/apis-explorer
