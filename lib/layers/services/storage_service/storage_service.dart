import 'package:dart_verse_backend/errors/models/storage_errors.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/impl/default_storage_server_handlers.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/repo/storage_server_handlers.dart';
import 'package:dart_verse_backend/layers/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse_backend/layers/services/storage_service/utils/buckets_store.dart';
import 'package:dart_verse_backend/layers/services/web_server/server_service.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore.dart';

import '../storage_buckets/repo/bucket_controller_repo.dart';

class StorageService {
  final App _app;
  final ServerService _serverService;
  late StorageServerHandlers _serverHandlers;
  bool _initialized = false;

  Future<void> init() async {
    await BucketsStore().init();
    _initialized = true;
  }

  Future<StorageBucket> createBucket(
    String name, {
    String? parentFolderPath,
    int? maxAllowedSize,
    BucketControllerRepo? controller,
    required String creatorId,
  }) async {
    if (!_initialized) {
      throw StorageServiceNotInitializedException();
    }
    StorageBucket storageBucket = StorageBucket(
      name,
      creatorId: creatorId,
      controller: controller,
      maxAllowedSize: maxAllowedSize,
      parentFolderPath: parentFolderPath,
    );
    return storageBucket;
  }

  StorageService(
    this._app,
    this._serverService, {
    StorageServerHandlers? storageServerHandlers,
  }) {
    _serverHandlers = storageServerHandlers ??
        DefaultStorageServerHandlers(
          app: _app,
        );
    _addEndpoints(
        //!
        );
  }
  // here i want to allowed adding files from http request by getting the file from the request then saving it here on the server
  // and providing a link for getting the percentage done from the file operation and that link will be for a ws server

  void _addEndpoints({
    bool jwtSecured = false,
    bool emailMustBeVerified = false,
    bool appIdSecured = false,
  }) {
    // paths
    String upload = _app.endpoints.storageEndpoints.upload;
    String download = _app.endpoints.storageEndpoints.download;
    String delete = _app.endpoints.storageEndpoints.delete;
    // handlers
    var router = Router()
      ..post(upload, _serverHandlers.upload)
      ..delete(delete, _serverHandlers.delete);
    _serverService.addRouter(
      router,
      appIdSecured: appIdSecured,
      emailMustBeVerified: emailMustBeVerified,
      jwtSecured: jwtSecured,
    );
    Router downloadRouter = Router()..get(download, _serverHandlers.download);
    _serverService.addRouter(downloadRouter, appIdSecured: false);
  }
}
