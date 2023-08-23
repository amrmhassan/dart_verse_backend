import 'package:dart_verse/layers/service_server/db_server/impl/default_db_server_handlers.dart';
import 'package:dart_verse/layers/service_server/db_server/repo/db_server_handlers.dart';
import 'package:dart_verse/layers/service_server/db_server/repo/db_server_settings.dart';
import 'package:dart_verse/layers/services/db_manager/db_service.dart';

class DefaultDbServerSettings implements DbServerSettings {
  @override
  late DbServerHandlers handlers;

  @override
  DbService dbService;

  DefaultDbServerSettings(
    this.dbService, {
    DbServerHandlers? dbServerHandlers,
  }) {
    handlers = dbServerHandlers ??
        DefaultDbServerHandlers(
          app: dbService.app,
          dbService: dbService,
        );
  }
}
