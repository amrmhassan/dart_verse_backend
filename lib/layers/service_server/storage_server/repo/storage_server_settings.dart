import 'package:dart_verse_backend/layers/service_server/storage_server/repo/storage_server_handlers.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';

abstract class StorageServerSettings {
  late StorageServerHandlers storageServerHandlers;
  late App app;
}
