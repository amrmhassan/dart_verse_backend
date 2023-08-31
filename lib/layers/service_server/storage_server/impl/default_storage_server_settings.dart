import 'package:dart_verse_backend/layers/service_server/storage_server/impl/default_storage_server_handlers.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/repo/storage_server_handlers.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/repo/storage_server_settings.dart';
import 'package:dart_verse_backend/layers/services/storage_service/storage_service.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';

class DefaultStorageServerSettings implements StorageServerSettings {
  @override
  App app;
  @override
  late StorageServerHandlers storageServerHandlers;

  @override
  StorageService storageService;

  DefaultStorageServerSettings(
    this.app,
    this.storageService, {
    StorageServerHandlers? cStorageServerHandlers,
  }) {
    storageServerHandlers =
        cStorageServerHandlers ?? DefaultStorageServerHandlers(app: app);
  }
}
