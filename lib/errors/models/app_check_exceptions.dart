// ignore_for_file: overridden_fields

import 'package:dart_verse_backend_new/errors/serverless_exception.dart';
import 'package:dart_verse_backend_new/constants/error_codes.dart';

//# app check exceptions
class AppCheckException extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  AppCheckException(
    this.message,
    this.code, {
    this.errorCode = 401,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

//? app auth exceptions
class NotAuthorizedApiKey extends AppCheckException {
  NotAuthorizedApiKey()
      : super(
          'Not authorized api key',
          ErrorCodes.notAuthorizedApiKey,
        );
}

class NotValidApiKey extends AppCheckException {
  NotValidApiKey()
      : super(
          'Not valid api key',
          ErrorCodes.notValidApiKey,
        );
}

class AppCheckNotProvider extends AppCheckException {
  AppCheckNotProvider()
      : super(
          'please provider the AppCheck to the App() ',
          ErrorCodes.appCheckNotProvided,
        );
}
