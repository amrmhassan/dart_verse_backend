import 'package:dart_verse_backend_new/constants/endpoints_constants.dart';
import 'package:dart_verse_backend_new/layers/service_server/db_server/repo/db_server_endpoints.dart';

class DefaultDbServerEndpoints implements DbServerEndpoints {
  @override
  String getDbConnLink = EndpointsConstants.getDbConnLink;
}
