import 'package:dart_verse_backend/layers/service_server/service_server.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/repo/storage_server_settings.dart';
import 'package:dart_verse_backend/layers/services/web_server/server_service.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/router.dart';

class StorageServer implements ServiceServerLayer {
  @override
  ServerService serverService;
  final StorageServerSettings _storageServerSettings;

  StorageServer(this.serverService, this._storageServerSettings);

  @override
  void addRouters() {
    bool jwtSecured = false;
    bool emailMustBeVerified = false;
    bool appIdSecured = false;
    // paths
    String upload = serverService.app.endpoints.storageEndpoints.upload;
    String download = serverService.app.endpoints.storageEndpoints.download;
    String delete = serverService.app.endpoints.storageEndpoints.delete;
    // handlers
    var router = Router()
      ..post(upload, _storageServerSettings.storageServerHandlers.upload)
      ..delete(delete, _storageServerSettings.storageServerHandlers.delete);
    serverService.addRouter(
      router,
      appIdSecured: appIdSecured,
      emailMustBeVerified: emailMustBeVerified,
      jwtSecured: jwtSecured,
    );
    Router downloadRouter = Router()
      ..get(download, _storageServerSettings.storageServerHandlers.download);
    serverService.addRouter(downloadRouter, appIdSecured: false);
  }
}
