import 'package:dart_verse_backend/constants/logger.dart';
import 'package:dart_verse_backend/dashboard_server/features/server/data/datasources/dashboard_server.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/db_settings/db_settings.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/entities/dashboard_server_settings.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/pipeline.dart';

class Dashboard {
  final DashboardSettings _dashboardSettings;
  late Pipeline _pipeline;
  late MongoDBProvider _mongoDBProvider;
  late App _app;
  late DbService _dbService;

  Pipeline get pipeline => _pipeline;

  Dashboard(this._dashboardSettings) {
    _mongoDBProvider = MongoDBProvider(_dashboardSettings.dashboardConnLink);
    DBSettings dbSettings = DBSettings(mongoDBProvider: _mongoDBProvider);
    _app = App(backendHost: 'http://localhost', dbSettings: dbSettings);
    _dbService = DbService(_app);
    _pipeline = Pipeline();
    run();
  }
  void run() {
    DashboardServer dashboardServer = DashboardServer(_dashboardSettings);
    _pipeline.addRouter(dashboardServer.router());

    _dbService.connectToDb();
    logger.i('connected to dashboard db');
  }
}
