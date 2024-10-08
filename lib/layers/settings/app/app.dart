// this app is the starting point of the server
// it will require settings for auth, database, realtime database, etc...
import 'package:dart_verse_backend_new/errors/models/app_exceptions.dart';
import 'package:dart_verse_backend_new/errors/models/storage_errors.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app_utils.dart';
import 'package:dart_verse_backend_new/layers/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse_backend_new/layers/settings/db_settings/db_settings.dart';
import 'package:dart_verse_backend_new/layers/settings/email_settings/email_settings.dart';
import 'package:dart_verse_backend_new/layers/settings/endpoints/endpoints.dart';
import 'package:dart_verse_backend_new/layers/settings/server_settings/entities/http_server_setting.dart';
import 'package:dart_verse_backend_new/layers/settings/storage_settings/storage_settings.dart';
import 'package:dart_verse_backend_new/layers/settings/user_data_settings/user_data_settings.dart';
import 'package:dart_verse_backend_new/utils/string_utils.dart';
import 'package:dart_verse_backend_new/layers/settings/server_settings/entities/dashboard_server_settings.dart';

//! i should keep track of collections and sub collections names in a string file or something

//? separate the servers settings
//? create a separate app for the dashboard
//? only pass the dashboard settings to the app settings of the dashboard app
//? separate the server settings
class App {
  late String _appName;
  final AuthSettings? _authSettings;
  final DBSettings? _dbSettings;
  final UserDataSettings? _userDataSettings;
  final EmailSettings? _emailSettings;
  final StorageSettings? _storageSettings;
  late EndpointsSettings _endpoints;
  final DashboardSettings? dashboardSettings;
  final HttpServerSetting mainServerSettings;

  /// this is the host you want to send to users in responses or emails <br>
  /// include the port also <br>
  /// this is basically the base url <br>
  late String _backendHost;
  App({
    /// app name must consist of numbers, english letters(capital, small) or spaces
    /// must be unique for each app, or data between apps will be overwritten
    required String appName,
    AuthSettings? authSettings,
    DBSettings? dbSettings,
    UserDataSettings? userDataSettings,
    EmailSettings? emailSettings,
    StorageSettings? storageSettings,
    EndpointsSettings? endpoints,
    required String? backendHost,
    required this.dashboardSettings,
    required this.mainServerSettings,
  })  : _authSettings = authSettings,
        _dbSettings = dbSettings,
        _userDataSettings = userDataSettings,
        _emailSettings = emailSettings,
        _storageSettings = storageSettings {
    _endpoints = endpoints ?? defaultEndpoints;
    _backendHost = backendHost?.strip('/') ?? '';
    _appName = AppUtils().appNameCleaner(appName);
  }

  String get appName => _appName;

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
