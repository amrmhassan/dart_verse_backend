// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse_backend_new/errors/serverless_exception.dart';

import 'package:dart_verse_backend_new/constants/error_codes.dart';

class ServerException extends ServerLessException {
  @override
  String message;
  @override
  final String code;
  @override
  int errorCode;

  ServerException(
    this.message,
    this.code, {
    this.errorCode = HttpStatus.badRequest,
  }) : super(code, errorCode: errorCode);
}

//? server exceptions

class NoRouterSetException extends ServerException {
  NoRouterSetException()
      : super(
          'please add at least one pipeline to the service before running server',
          ErrorCodes.noRouterSet,
        );
}

class NoAuthServerSettingsException extends ServerException {
  NoAuthServerSettingsException()
      : super(
          'once you allow for auto auth for the server you must provide auth server settings try the DefaultAuthServerSettings or implement your own ',
          ErrorCodes.noAuthServerSettings,
        );
}

class RequestBodyError extends ServerException {
  RequestBodyError([String? msg])
      : super(
          'bad body data: ${msg ?? "please check documentation"}',
          ErrorCodes.requestBoyError,
          errorCode: HttpStatus.badRequest,
        );
}
