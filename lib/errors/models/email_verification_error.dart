// ignore_for_file: overridden_fields

import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/constants/error_codes.dart';

class EmailVerificationException extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  EmailVerificationException(
    this.message,
    this.code, {
    this.errorCode = 400,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

//? email verification errors
class FailedToVerifyException extends EmailVerificationException {
  FailedToVerifyException(int code)
      : super(
          'can\'t verify user $code',
          ErrorCodes.failedToVerify,
        );
}

class FailedToStartVerificationException extends EmailVerificationException {
  FailedToStartVerificationException(String error)
      : super(
          'failed to start user verification, $error',
          ErrorCodes.failedToVerify,
        );
}

class EarlyVerificationAskingException extends EmailVerificationException {
  EarlyVerificationAskingException(int seconds)
      : super(
          'please wait $seconds seconds before asking for another email verification',
          ErrorCodes.earlyEmailVerification,
        );
}

class UserIsAlreadyVerifiedException extends EmailVerificationException {
  UserIsAlreadyVerifiedException()
      : super(
          'user is already verified',
          ErrorCodes.userAlreadyVerified,
          errorCode: 409,
        );
}
