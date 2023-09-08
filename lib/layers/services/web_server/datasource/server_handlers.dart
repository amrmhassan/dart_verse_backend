import 'dart:async';

import 'package:dart_verse_backend/constants/endpoints_constants.dart';
import 'package:dart_verse_backend/constants/header_fields.dart';
import 'package:dart_verse_backend/errors/models/app_check_exceptions.dart';
import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/utils/send_response.dart';
import 'package:dart_webcore/dart_webcore.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

class ServerHandlers {
  final App _app;

  const ServerHandlers(this._app);
  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future<PassedHttpEntity> Function() method,
  ) async {
    try {
      return await method();
    } on AppCheckException catch (e) {
      return SendResponse.sendForbidden(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ServerLessException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

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
    RouterInfo routerInfo = RouterInfo(router, appIdSecured: false);

    return routerInfo;
  }

  FutureOr<PassedHttpEntity> checkApp(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      var appCheck = _app.appCheck;
      if (appCheck == null) {
        return request;
      }
      String? apiHash = request.headers.value(HeaderFields.apiHash);
      await appCheck.validateApiHash(apiHash);
      return request;
    });
  }
}
