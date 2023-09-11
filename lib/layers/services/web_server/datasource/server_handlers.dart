import 'package:dart_verse_backend/constants/endpoints_constants.dart';
import 'package:dart_verse_backend/layers/services/web_server/models/router_info.dart';
import 'package:dart_webcore/dart_webcore.dart';

class ServerHandlers {
  RouterInfo getServerRouter() {
    Router router = Router()
      ..get(EndpointsConstants.serverAlive,
          (request, response, pathArgs) => response.write('server is live'))
      ..get(
        EndpointsConstants.serverTime,
        (request, response, pathArgs) => response.write(
          DateTime.now().toIso8601String(),
        ),
      );
    RouterInfo routerInfo = RouterInfo(router);

    return routerInfo;
  }
}
