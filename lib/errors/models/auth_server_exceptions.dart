// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/constants/error_codes.dart';

class AuthServerExceptions extends ServerLessException {
  @override
  String message;
  @override
  final String code;
  @override
  int errorCode;

  AuthServerExceptions(
    this.message,
    this.code, {
    this.errorCode = HttpStatus.badRequest,
  }) : super(code, errorCode: errorCode);
}

class NoAuthServerSettings extends AuthServerExceptions {
  NoAuthServerSettings()
      : super(
          'please provide authServer to ServerService',
          ErrorCodes.noAuthServerProvided,
        );
}
