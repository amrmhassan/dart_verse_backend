// this app is the starting point of the server
// it will require settings for auth, database, realtime database, etc...
import 'package:dart_verse/errors/models/app_exceptions.dart';
import 'package:dart_verse/errors/models/storage_errors.dart';
import 'package:dart_verse/layers/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/layers/settings/db_settings/db_settings.dart';
import 'package:dart_verse/layers/settings/email_settings/email_settings.dart';
import 'package:dart_verse/layers/settings/endpoints/endpoints.dart';
import 'package:dart_verse/layers/settings/server_settings/server_settings.dart';
import 'package:dart_verse/layers/settings/storage_settings/storage_settings.dart';
import 'package:dart_verse/layers/settings/user_data_settings/user_data_settings.dart';
import 'package:dart_verse/utils/string_utils.dart';

//! i should keep track of collections and sub collections names in a string file or something

class App {
  final AuthSettings? _authSettings;
  final DBSettings? _dbSettings;
  final UserDataSettings? _userDataSettings;
  final ServerSettings? _serverSettings;
  final EmailSettings? _emailSettings;
  final StorageSettings? _storageSettings;
  late EndpointsSettings _endpoints;

  /// this is the host you want to send to users in responses or emails <br>
  /// include the port also <br>
  /// this is basically the base url <br>
  late String _backendHost;
  App({
    AuthSettings? authSettings,
    DBSettings? dbSettings,
    UserDataSettings? userDataSettings,
    ServerSettings? serverSettings,
    EmailSettings? emailSettings,
    StorageSettings? storageSettings,
    EndpointsSettings? endpoints,
    required String backendHost,
  })  : _authSettings = authSettings,
        _dbSettings = dbSettings,
        _userDataSettings = userDataSettings,
        _serverSettings = serverSettings,
        _emailSettings = emailSettings,
        _storageSettings = storageSettings {
    _endpoints = endpoints ?? defaultEndpoints;
    _backendHost = backendHost.strip('/');
  }

  //# getting difference settings instances
  AuthSettings get authSettings {
    if (_authSettings == null) {
      throw NoAuthSettings();
    }
    return _authSettings!;
  }

  UserDataSettings get userDataSettings {
    if (_userDataSettings == null) {
      throw NoUserDataSettingsException();
    }
    return _userDataSettings!;
  }

  DBSettings get dbSettings {
    if (_dbSettings == null) {
      throw NoDbSettingsExceptions();
    }
    return _dbSettings!;
  }

  ServerSettings get serverSettings {
    if (_serverSettings == null) {
      throw NoServerSettingsExceptions();
    }
    return _serverSettings!;
  }

  EmailSettings get emailSettings {
    if (_emailSettings == null) {
      throw NoEmailSettingsException();
    }
    return _emailSettings!;
  }

  EndpointsSettings get endpoints {
    return _endpoints;
  }

  StorageSettings get storageSettings {
    if (_storageSettings == null) {
      throw NoStorageSettingsProvided();
    }
    return _storageSettings!;
  }

  String get backendHost {
    return _backendHost;
  }
}
