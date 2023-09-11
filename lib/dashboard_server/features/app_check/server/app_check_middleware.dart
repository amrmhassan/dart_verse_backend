import 'dart:async';

import 'package:dart_verse_backend/constants/endpoints_constants.dart';
import 'package:dart_verse_backend/constants/header_fields.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/app_check.dart';
import 'package:dart_verse_backend/errors/models/app_check_exceptions.dart';
import 'package:dart_verse_backend/errors/models/server_errors.dart';
import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/utils/send_response.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

class AppCheckMiddleware {
  final DbService dbService;
  final App _app;
  AppCheck? appCheck;

  AppCheckMiddleware(this._app, this.dbService) {
    var appCheckSettings = _app.dashboardSettings?.appCheckSettings;
    if (appCheckSettings != null) {
      appCheck = AppCheck(
        encrypterSecretKey: appCheckSettings.encrypterSecretKey,
        clientApiAllowance: appCheckSettings.clientApiAllowance,
        dbService: dbService,
      );
    }
  }
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

  FutureOr<PassedHttpEntity> checkApp(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      String path = request.uri.path;
      if (path == EndpointsConstants.serverTime) {
        return request;
      }
      if (appCheck == null) {
        return request;
      }

      String? apiHash = request.headers.value(HeaderFields.apiHash);
      String? apiKey = request.headers.value(HeaderFields.apiKey);
      if (apiKey == null) {
        throw RequestBodyError('please provider the `apiKey` in the headers');
      }
      await appCheck!.validateApiHash(apiKey, apiHash);
      return request;
    });
  }
}
