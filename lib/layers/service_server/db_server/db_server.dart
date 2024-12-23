import 'package:dart_verse_backend_new/layers/service_server/db_server/repo/db_server_settings.dart';
import 'package:dart_verse_backend_new/layers/service_server/service_server.dart';
import 'package:dart_verse_backend_new/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:dart_webcore_new/dart_webcore_new/routing/impl/router.dart';

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
