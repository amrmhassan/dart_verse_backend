import 'package:dart_verse_backend_new/layers/service_server/db_server/repo/db_server_handlers.dart';
import 'package:dart_verse_backend_new/layers/services/db_manager/db_service.dart';

abstract class DbServerSettings {
  late DbServerHandlers handlers;
  late DbService dbService;
}
