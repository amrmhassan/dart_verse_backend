import 'package:dart_verse_backend/dashboard_server/constants/dashboard_endpoints.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/entities/dashboard_server_settings.dart';
import 'package:dart_webcore/dart_webcore.dart';

class DashboardServer {
  final DashboardSettings dashboardSettings;

  DashboardServer(this.dashboardSettings);

  Router router() {
    Router router = Router()
      ..get(DashboardEndpoints.login,
          (request, response, pathArgs) => response.write('object'));
    return router;
  }
}
