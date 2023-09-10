// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/constants/error_codes.dart';

class ApiKeyException extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  ApiKeyException(
    this.message,
    this.code, {
    this.errorCode = HttpStatus.unauthorized,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

class NoApiKeyFound extends ApiKeyException {
  NoApiKeyFound()
      : super(
          'No api key found for this hash',
          ErrorCodes.noApiKeyFound,
        );
}

class InactiveApiKey extends ApiKeyException {
  InactiveApiKey()
      : super(
          'This api key is not active',
          ErrorCodes.apiKeyNotActive,
        );
}

class ExpiredApiKey extends ApiKeyException {
  ExpiredApiKey()
      : super(
          'This api key is expired',
          ErrorCodes.apiKeyNotActive,
        );
}
