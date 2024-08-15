import 'dart:async';

import 'package:dart_verse_backend_new/constants/context_fields.dart';
import 'package:dart_verse_backend_new/constants/header_fields.dart';
import 'package:dart_verse_backend_new/errors/models/auth_errors.dart';
import 'package:dart_verse_backend_new/errors/serverless_exception.dart';
import 'package:dart_verse_backend_new/layers/services/auth/auth_service.dart';
import 'package:dart_verse_backend_new/layers/service_server/auth_server/repo/auth_middlewares.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

import '../../../settings/server_settings/utils/send_response.dart';

class DefaultAuthMiddlewares implements AuthServerMiddlewares {
  @override
  late AuthService authService;

  DefaultAuthMiddlewares(this.authService);

  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future<PassedHttpEntity> Function() method,
  ) async {
    try {
      return await method();
    } on JwtAuthException catch (e) {
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

  @override
  FutureOr<PassedHttpEntity> checkJwtForUserId(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var context = request.context;
      var jwtString = context[ContextFields.jwt];

      if (jwtString is! String) {
        throw ProvidedJwtNotValid(4);
      }

      var userId = await authService.loginWithJWT(jwtString);
      if (userId == null) {
        throw AuthNotAllowedException();
      }
      request.context[ContextFields.userId] = userId;

      return request;
    });
  }

  @override
  FutureOr<PassedHttpEntity> checkJwtInHeaders(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var headers = request.headers;
      var jwt = headers.value(HeaderFields.authorization);
      if (jwt == null) {
        throw NoAuthHeaderException();
      }

      jwt = jwt
        ..toString()
        ..replaceAll('  ', ' ')
        ..trim();
      var parts = jwt.split(' ');
      int length = parts.length;
      String bearer = parts.first;
      String jwtString = parts.last;
      if (length != 2) {
        throw AuthHeaderNotValidException();
      }
      if (bearer != HeaderFields.bearer) {
        throw AuthHeaderNotValidException();
      }
      if (jwtString.isEmpty) {
        throw ProvidedJwtNotValid(1);
      }
      request.context[ContextFields.jwt] = jwtString;

      return request;
    });
  }

  @override
  FutureOr<PassedHttpEntity> checkUserEmailVerified(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      // this userId will be provided only if the user is allowed to sign in with the provided jwt from the checkJwtForUserId middleware
      String? userId = request.context[ContextFields.userId];
      if (userId == null) {
        throw AuthNotAllowedException();
      }

      var verified = await authService.checkUserVerified(userId);
      if (verified == null) {
        throw NoUserRegisteredException();
      }
      if (verified != true) {
        throw UserEmailNotVerified();
      }

      return request;
    });
  }
}
