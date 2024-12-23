import 'dart:async';

import 'package:dart_verse_backend_new/constants/body_fields.dart';
import 'package:dart_verse_backend_new/errors/models/database_errors.dart';
import 'package:dart_verse_backend_new/errors/models/server_errors.dart';
import 'package:dart_verse_backend_new/errors/serverless_exception.dart';
import 'package:dart_verse_backend_new/layers/service_server/db_server/repo/db_server_handlers.dart';
import 'package:dart_verse_backend_new/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:dart_verse_backend_new/layers/settings/server_settings/utils/send_response.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/impl/request_holder.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/impl/response_holder.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/repo/passed_http_entity.dart';

class DefaultDbServerHandlers implements DbServerHandlers {
  @override
  App app;

  @override
  DbService dbService;

  DefaultDbServerHandlers({
    required this.app,
    required this.dbService,
  });

  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future Function() method,
  ) async {
    try {
      return await method();
    } on ServerException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on DBException catch (e) {
      return SendResponse.sendAuthErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  @override
  FutureOr<PassedHttpEntity> getConnLink(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      String? dbConnLink = app.dbSettings.mongoDBProvider?.connLink.getConnLink;
      if (dbConnLink == null) {
        throw MongoDbNotConnectedException();
      }
      return SendResponse.sendDataToUser(
        response,
        dbConnLink,
        dataFieldName: BodyFields.connLink,
      );
    });
  }
}
