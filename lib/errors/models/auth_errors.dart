// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/constants/error_codes.dart';

//# auth exceptions
class AuthException extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  AuthException(
    this.message,
    this.code, {
    this.errorCode = 401,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

//? app auth exceptions
class NoAppIdException extends AuthException {
  NoAppIdException()
      : super(
          'please provide your app id in the headers as appid:<put_your_app_id_here>',
          ErrorCodes.noAppIdProvided,
        );
}

//? register exceptions
class RegisterUserException extends AuthException {
  @override
  String message;
  @override
  String code;
  @override
  int errorCode;

  RegisterUserException(
    this.message,
    this.code, {
    this.errorCode = 401,
  }) : super(
          message,
          code,
          errorCode: errorCode,
        );
}

//? jwt auth errors
class JwtAuthException extends AuthException {
  @override
  String message;
  @override
  String code;
  @override
  int errorCode;

  JwtAuthException(
    this.message,
    this.code, {
    this.errorCode = 401,
  }) : super(
          message,
          code,
          errorCode: errorCode,
        );
}

class DuplicateEmailException extends RegisterUserException {
  DuplicateEmailException()
      : super(
          'email already exists',
          ErrorCodes.duplicateEmail,
          errorCode: HttpStatus.conflict,
        );
}

//? login exceptions
class LoginUserException extends AuthException {
  @override
  String message;
  @override
  String code;
  @override
  int errorCode;

  LoginUserException(
    this.message,
    this.code, {
    this.errorCode = 401,
  }) : super(
          message,
          code,
          errorCode: errorCode,
        );
}

class NoUserRegisteredException extends LoginUserException {
  NoUserRegisteredException()
      : super(
          'no user registered',
          ErrorCodes.noUserRegistered,
        );
}

class InvalidPassword extends LoginUserException {
  InvalidPassword()
      : super(
          'invalid password',
          ErrorCodes.invalidPassword,
        );
}

class LoginExceedException extends LoginUserException {
  LoginExceedException()
      : super(
          'logged in too much, too much active sessions, try logging out from all of your devices',
          ErrorCodes.activeJwtExceed,
          errorCode: HttpStatus.tooManyRequests,
        );
}

//? jwt actual exceptions
class NoAuthHeaderException extends JwtAuthException {
  NoAuthHeaderException()
      : super(
          'please provide the `authorization` in headers',
          ErrorCodes.noAuthHeaderProvided,
          errorCode: HttpStatus.badRequest,
        );
}

class AuthHeaderNotValidException extends JwtAuthException {
  AuthHeaderNotValidException()
      : super(
          'authorization header is not valid',
          ErrorCodes.authHeaderNotValid,
          errorCode: HttpStatus.badRequest,
        );
}

class ProvidedJwtNotValid extends JwtAuthException {
  ProvidedJwtNotValid(int code)
      : super(
          'provided jwt is not valid with type: $code',
          ErrorCodes.jwtNotValid,
          errorCode: HttpStatus.badRequest,
        );
}

class AuthNotAllowedException extends JwtAuthException {
  AuthNotAllowedException()
      : super(
          'auth operation not allowed',
          ErrorCodes.jwtAccessNotAllowed,
        );
}

class JwtEmailVerificationExpired extends JwtAuthException {
  JwtEmailVerificationExpired()
      : super(
          'the token is expired, try get a new one',
          ErrorCodes.jwtEmailVerifyExpired,
        );
}

class UserNotFoundToVerify extends JwtAuthException {
  UserNotFoundToVerify()
      : super(
          'can\'t find the user to verify',
          ErrorCodes.userNotFoundToVerify,
          errorCode: HttpStatus.notFound,
        );
}

class UserNotFoundException extends JwtAuthException {
  UserNotFoundException()
      : super(
          'can\'t find the user ',
          ErrorCodes.userNotFound,
          errorCode: HttpStatus.notFound,
        );
}

class NonAuthorizedAppId extends JwtAuthException {
  NonAuthorizedAppId()
      : super(
          'the provided app id isn\'t authorized',
          ErrorCodes.notAuthorizedAppId,
        );
}

class UserEmailNotVerified extends JwtAuthException {
  UserEmailNotVerified()
      : super(
          'user email not verified, please verify first',
          ErrorCodes.userEmailNotVerified,
        );
}
