import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
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
import 'package:dart_webcore/dart_webcore/routing/impl/pipeline.dart';

class Dashboard {
  final DashboardSettings _dashboardSettings;
  final App _mainApp;
  late Pipeline _pipeline;
  late MongoDBProvider _mongoDBProvider;
  late DbService _dbService;

  Pipeline get pipeline => _pipeline;
  late App _app;

  Dashboard(this._dashboardSettings, this._mainApp) {
    if (_mainApp.dashboardSettings == null) return;
    _mongoDBProvider = MongoDBProvider(_dashboardSettings.dashboardConnLink);
    DBSettings dbSettings = DBSettings(mongoDBProvider: _mongoDBProvider);
    AuthSettings authSettings = AuthSettings(
      jwtSecretKey: SecretKey('jwtSecretKey'),
    );
    _app = App(
      backendHost: null,
      dbSettings: dbSettings,
      dashboardSettings: null,
      authSettings: authSettings,
      mainServerSettings: _mainApp.dashboardSettings!.dashboardServerSettings,
    );

    _dbService = DbService(_mainApp);
    _pipeline = Pipeline();
    run();
  }
  Future<void> _handleServices() async {
    // server service
    DashboardServer dashboardServer = DashboardServer(_dashboardSettings);
    _pipeline.addRouter(dashboardServer.router());
    DbService dbService = DbService(_app);
    MongoDbAuthProvider authProvider = MongoDbAuthProvider(_app, dbService);
    AuthService authService = AuthService(authProvider);
    AuthServerSettings authServerSettings =
        DefaultAuthServerSettings(authService);
    var authServer = AuthServer(_app, authServerSettings);
    ServerService serverService = ServerService(
      _app,
      authServerSettings: authServerSettings,
    );

    await serverService.runServers(authServer: authServer);
  }

  void run() async {
    await _dbService.connectToDb();
    await _handleServices();
  }
}
