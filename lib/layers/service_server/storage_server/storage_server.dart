import 'package:dart_verse_backend_new/constants/endpoints_constants.dart';
import 'package:dart_verse_backend_new/layers/service_server/service_server.dart';
import 'package:dart_verse_backend_new/layers/service_server/storage_server/repo/storage_server_settings.dart';
import 'package:dart_verse_backend_new/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/router.dart';

class StorageServer implements ServiceServerLayer {
  @override
  App app;
  final StorageServerSettings _storageServerSettings;

  StorageServer(this.app, this._storageServerSettings);

  @override
  List<RouterInfo> addRouters() {
    var handlers = _storageServerSettings.storageServerHandlers;
    bool jwtSecured = false;
    bool emailMustBeVerified = false;
    // paths
    String upload = app.endpoints.storageEndpoints.upload;
    String download = app.endpoints.storageEndpoints.download;
    String delete = app.endpoints.storageEndpoints.delete;
    String listChildren = EndpointsConstants.listChildren;
    // handlers
    var router = Router()
      ..post(upload, handlers.upload)
      ..get(listChildren, handlers.listChildren)
      ..delete(delete, handlers.delete);

    RouterInfo routerInfo = RouterInfo(
      router,
      emailMustBeVerified: emailMustBeVerified,
      jwtSecured: jwtSecured,
    );
    Router downloadRouter = Router()
      ..get(download, _storageServerSettings.storageServerHandlers.download);

    RouterInfo downloadRouterInfo = RouterInfo(downloadRouter);
    return [routerInfo, downloadRouterInfo];
  }
}
