import 'package:dart_verse/layers/service_server/db_server/repo/db_server_settings.dart';
import 'package:dart_verse/layers/service_server/service_server.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/router.dart';
import 'package:dart_verse/layers/settings/app/app.dart';

class DBServer implements ServiceServerLayer {
  final App _app;
  final DbServerSettings _dbServerSettings;

  const DBServer(this._app, this._dbServerSettings);
  @override
  Router getRouter() {
    String getConnLinkEndpoint = _app.endpoints.dbEndpoints.getDbConnLink;

    Router router = Router()
      ..get(
        getConnLinkEndpoint,
        _dbServerSettings.handlers.getConnLink,
      );
    return router;
  }
}
