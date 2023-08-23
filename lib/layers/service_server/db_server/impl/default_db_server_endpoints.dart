import 'package:dart_verse/constants/endpoints_constants.dart';
import 'package:dart_verse/layers/service_server/db_server/repo/db_server_endpoints.dart';

class DefaultDbServerEndpoints implements DbServerEndpoints {
  @override
  String getDbConnLink = EndpointsConstants.getDbConnLink;
}
