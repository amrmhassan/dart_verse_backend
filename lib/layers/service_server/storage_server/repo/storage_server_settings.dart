import 'package:dart_verse_backend_new/layers/service_server/storage_server/repo/storage_server_handlers.dart';
import 'package:dart_verse_backend_new/layers/services/storage_service/storage_service.dart';

abstract class StorageServerSettings {
  late StorageServerHandlers storageServerHandlers;
  late StorageService storageService;
}
