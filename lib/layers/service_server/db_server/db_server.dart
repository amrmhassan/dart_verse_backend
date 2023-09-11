import 'package:dart_verse_backend/layers/service_server/db_server/repo/db_server_settings.dart';
import 'package:dart_verse_backend/layers/service_server/service_server.dart';
import 'package:dart_verse_backend/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/router.dart';

class DBServer implements ServiceServerLayer {
  final DbServerSettings _dbServerSettings;
  @override
  App app;

  DBServer(this.app, this._dbServerSettings);
  @override
  List<RouterInfo> addRouters() {
    String getConnLinkEndpoint = app.endpoints.dbEndpoints.getDbConnLink;

    Router router = Router()
      ..get(
        getConnLinkEndpoint,
        _dbServerSettings.handlers.getConnLink,
      );
    RouterInfo routerInfo = RouterInfo(router);
    return [routerInfo];
  }
}
