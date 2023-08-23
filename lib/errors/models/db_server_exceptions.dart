// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse/constants/error_codes.dart';
import 'package:dart_verse/errors/serverless_exception.dart';

class DbServerExceptions extends ServerLessException {
  @override
  String message;
  @override
  final String code;
  @override
  int errorCode;

  DbServerExceptions(
    this.message,
    this.code, {
    this.errorCode = HttpStatus.badRequest,
  }) : super(code, errorCode: errorCode);
}

class NoAuthServerSettings extends DbServerExceptions {
  NoAuthServerSettings()
      : super(
          'please provide dbServer to ServerService',
          ErrorCodes.noDbServerProvided,
        );
}
