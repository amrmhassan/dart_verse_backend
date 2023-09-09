import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_info_datasource.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/server/api_crud_server.dart';
import 'package:dart_verse_backend/dashboard_server/features/server/data/datasources/dashboard_server.dart';
import 'package:dart_verse_backend/features/auth_db_provider/impl/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/auth_server.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/impl/default_auth_server_settings.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/repo/auth_server_settings.dart';
import 'package:dart_verse_backend/layers/services/auth/auth_service.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend/layers/services/web_server/server_service.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse_backend/layers/settings/db_settings/db_settings.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/entities/dashboard_server_settings.dart';
import 'package:dart_verse_backend/layers/settings/user_data_settings/user_data_settings.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/pipeline.dart';

class Dashboard {
  final DashboardSettings _dashboardSettings;
  final App _mainApp;

  Pipeline get pipeline => _pipeline;

  Dashboard(this._dashboardSettings, this._mainApp) {
    if (_mainApp.dashboardSettings == null) return;
    _mongoDBProvider = MongoDBProvider(_dashboardSettings.dashboardConnLink);
    DBSettings dbSettings = DBSettings(mongoDBProvider: _mongoDBProvider);
    AuthSettings authSettings = AuthSettings(
      jwtSecretKey: _mainApp.authSettings.jwtSecretKey,
      maximumActiveJwts: 10000000,
    );
    UserDataSettings userDataSettings = const UserDataSettings();
    _app = App(
      backendHost: null,
      dbSettings: dbSettings,
      dashboardSettings: null,
      authSettings: authSettings,
      userDataSettings: userDataSettings,
      mainServerSettings: _mainApp.dashboardSettings!.dashboardServerSettings,
    );

    _pipeline = Pipeline();
  }

  //? main props, services
  late Pipeline _pipeline;
  late MongoDBProvider _mongoDBProvider;
  late App _app;
  late AuthServer _authServer;
  // services
  late DbService _dbService;
  late AuthService _authService;
  late ServerService _serverService;
  Future<void> _handleServices() async {
    // server service
    DashboardServer dashboardServer = DashboardServer(_dashboardSettings);
    _pipeline.addRouter(dashboardServer.router());
    _dbService = DbService(_app);
    MongoDbAuthProvider authProvider = MongoDbAuthProvider(_app, _dbService);
    _authService = AuthService(authProvider);

    AuthServerSettings authServerSettings =
        DefaultAuthServerSettings(_authService);
    _authServer = AuthServer(_app, authServerSettings);
    _serverService = ServerService(
      _app,
      authServerSettings: authServerSettings,
    );
  }

  Future<void> _initData() async {
    await _dbService.connectToDb();
    try {
      await _authService.registerUser(email: 'verse', password: 'verse');
    } catch (e) {
      //
    }
    _addHandlers();
    await _serverService.runServers(authServer: _authServer);
  }

  void _addHandlers() {
    AppCheckSettings? settings = _mainApp.dashboardSettings?.appCheckSettings;
    if (settings == null) {
      return;
    }
    ApiKeyInfoDatasource apiKeyInfoDatasource =
        ApiKeyInfoDatasource(_dbService, settings.encrypterSecretKey);
    ApiCRUDServer apiCheckServer = ApiCRUDServer(apiKeyInfoDatasource);
    _serverService.addRouter(apiCheckServer.getRouter());
  }

  void run() async {
    await _handleServices();
    await _initData();
  }
}
