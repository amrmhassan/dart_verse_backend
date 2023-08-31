import 'package:dart_verse_backend/layers/service_server/db_server/repo/db_server_settings.dart';
import 'package:dart_verse_backend/layers/service_server/service_server.dart';
import 'package:dart_verse_backend/layers/services/web_server/server_service.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/router.dart';

class DBServer implements ServiceServerLayer {
  final DbServerSettings _dbServerSettings;
  ServerService serverService;

  DBServer(this.serverService, this._dbServerSettings);
  @override
  List<Router> addRouters() {
    String getConnLinkEndpoint =
        serverService.app.endpoints.dbEndpoints.getDbConnLink;

    Router router = Router()
      ..get(
        getConnLinkEndpoint,
        _dbServerSettings.handlers.getConnLink,
      );
    return [router];
  }
}
