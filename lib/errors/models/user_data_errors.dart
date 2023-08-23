// ignore_for_file: overridden_fields

import 'package:dart_verse_backend/errors/serverless_exception.dart';

import 'package:dart_verse_backend/constants/error_codes.dart';

abstract class UserDataExceptions extends ServerLessException {
  @override
  String message;

  @override
  String code;
  UserDataExceptions(this.message, this.code) : super(code);
}

class UserDataServiceDependOnAuthServiceException extends UserDataExceptions {
  UserDataServiceDependOnAuthServiceException()
      : super(
          'the _authService.authDbProvider in userDataService does\'nt match any of the userDataServiceDbProviders, please check your userDataDbProviders',
          ErrorCodes.userDataAuthService,
        );
}
