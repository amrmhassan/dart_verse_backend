import 'dart:async';

import 'package:dart_verse_backend_new/layers/services/auth/auth_service.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/impl/request_holder.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/impl/response_holder.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/repo/passed_http_entity.dart';

abstract class AuthServerMiddlewares {
  late AuthService authService;

  FutureOr<PassedHttpEntity> checkJwtInHeaders(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
  FutureOr<PassedHttpEntity> checkJwtForUserId(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );

  FutureOr<PassedHttpEntity> checkUserEmailVerified(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
}
