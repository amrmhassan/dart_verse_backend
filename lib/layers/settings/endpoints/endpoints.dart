import 'package:dart_verse_backend_new/layers/service_server/db_server/impl/default_db_server_endpoints.dart';
import 'package:dart_verse_backend_new/layers/service_server/db_server/repo/db_server_endpoints.dart';
import 'package:dart_verse_backend_new/layers/settings/endpoints/impl/default_storage_endpoints.dart';
import 'package:dart_verse_backend_new/layers/settings/endpoints/repo/auth_endpoints.dart';
import 'package:dart_verse_backend_new/layers/settings/endpoints/impl/default_auth_endpoints.dart';
import 'package:dart_verse_backend_new/layers/settings/endpoints/repo/storage_endpoints.dart';

class EndpointsSettings {
  final AuthEndpoints authEndpoints;
  final StorageEndpoints storageEndpoints;
  final DbServerEndpoints dbEndpoints;

  const EndpointsSettings({
    required this.authEndpoints,
    required this.storageEndpoints,
    required this.dbEndpoints,
  });
}

EndpointsSettings defaultEndpoints = EndpointsSettings(
  authEndpoints: DefaultAuthEndpoints(),
  storageEndpoints: DefaultStorageEndpoints(),
  dbEndpoints: DefaultDbServerEndpoints(),
);
