// ignore_for_file: overridden_fields

import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/constants/error_codes.dart';

class AppExceptions extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  AppExceptions(
    this.message,
    this.code, {
    this.errorCode = 500,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

class EncryptionException extends AppExceptions {
  EncryptionException([String? message])
      : super(
          'An error happened while encryption: $message',
          ErrorCodes.notAuthorizedApiKey,
        );
}

class DecryptionException extends AppExceptions {
  DecryptionException(String message)
      : super(
          'An error happened while decryption: $message',
          ErrorCodes.notValidApiKey,
        );
}
