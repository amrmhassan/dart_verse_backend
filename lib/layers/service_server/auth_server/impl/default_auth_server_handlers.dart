import 'dart:async';
import 'dart:convert';

import 'package:dart_verse/constants/body_fields.dart';
import 'package:dart_verse/constants/context_fields.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/constants/path_fields.dart';
import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/server_errors.dart';
import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse/layers/services/auth/auth_service.dart';
import 'package:dart_verse/layers/services/email/email_service.dart';
import 'package:dart_verse/layers/services/user_data/user_data_service.dart';
import 'package:dart_verse/layers/service_server/auth_server/repo/auth_server_handlers.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';
import 'package:mailer/mailer.dart';

import '../../../settings/server_settings/utils/send_response.dart';

class DefaultAuthServerHandlers implements AuthServerHandlers {
  @override
  AuthService authService;

  // @override
  // AuthBodyKeys defaultAuthBodyKeys;

  @override
  EmailVerificationProvider emailVerificationProvider;

  DefaultAuthServerHandlers(
    this.authService,
    // this.defaultAuthBodyKeys,
    this.emailVerificationProvider,
  );

  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future Function() method,
  ) async {
    try {
      return await method();
    } on ServerException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on AuthException catch (e) {
      return SendResponse.sendAuthErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  @override
  FutureOr<PassedHttpEntity> login(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(
      request,
      response,
      pathArgs,
      () async {
        dynamic data;
        try {
          data = await request.readAsJson();
        } catch (e) {
          throw RequestBodyError();
        }
        String emailKey = BodyFields.email;
        String passwordKey = BodyFields.password;
        String? email = data[emailKey];
        String? password = data[passwordKey];
        if (email == null || password == null) {
          throw RequestBodyError('email and password can\'t be empty');
        }

        String jwt = await authService.loginWithEmail(
          email: email,
          password: password,
        );

        UserDataService userDataService = UserDataService(authService);
        var userData = await userDataService.getUserDataByEmail(email) ?? {};

        Map<String, dynamic> resData = {
          BodyFields.userData: userData,
          ContextFields.jwt: jwt,
        };

        return SendResponse.sendDataToUser(
          response,
          resData,
        );
      },
    );
  }

  @override
  FutureOr<PassedHttpEntity> register(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(
      request,
      response,
      pathArgs,
      () async {
        var data = await request.readAsJson();
        String emailKey = BodyFields.email;
        String passwordKey = BodyFields.password;
        String userDataKey = BodyFields.userData;

        String? email = data[emailKey];
        String? password = data[passwordKey];
        Map<String, dynamic> userData = data[userDataKey] ?? {};

        if (email == null || password == null) {
          throw RequestBodyError('email and password can\'t be empty');
        }

        String jwt = await authService.registerUser(
          email: email,
          password: password,
          userData: userData,
          customUserID: null,
        );

        UserDataService userDataService = UserDataService(authService);
        var loadedUserData =
            await userDataService.getUserDataByEmail(email) ?? {};

        Map<String, dynamic> resData = {
          BodyFields.userData: loadedUserData,
          ContextFields.jwt: jwt,
        };

        return SendResponse.sendDataToUser(
          response,
          resData,
        );
      },
    );
  }

  @override
  FutureOr<PassedHttpEntity> getVerificationEmail(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    String verifyEmailEndpoint,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      var body = await request.readAsJson();
      var email = body[ModelFields.email];

      if (email is! String) {
        throw RequestBodyError('email can\'t be empty');
      }
      String token = await authService.createVerifyEmailToken(
        email,
        allowNewJwtAfter:
            emailVerificationProvider.allowNewVerificationEmailAfter,
        verifyLinkExpiresAfter:
            emailVerificationProvider.verifyLinkExpiresAfter,
      );

      // JWT
      //     .verify(
      //         token, authService.authDbProvider.app.authSettings.jwtSecretKey)
      //     .payload;
      // here i need to send that email to the user
      EmailService emailService = EmailService(authService.authDbProvider.app);
      Message message = getEmailVerificationMessage(
        mailTo: email,
        from: 'Dart Verse',
        subject: 'Test Email Verification',
      );
      String verificationLink = (verifyEmailEndpoint.endsWith('/')
              ? verifyEmailEndpoint
              : '$verifyEmailEndpoint/') +
          token;

      await emailService.sendFromTemplateFile(
        message,
        'D:/Study And Work/Work/projects/flutter/Dart Mastery/dart_verse/templates/verification.html',
        {
          'name': email,
          'verify_link': verificationLink,
          'sender_name': 'Dart Verse',
        },
      );

      return SendResponse.sendDataToUser(
        response,
        'Email sent successfully',
        dataFieldName: 'msg',
      );
    });
  }

  @override
  FutureOr<PassedHttpEntity> verifyEmail(RequestHolder request,
      ResponseHolder response, Map<String, dynamic> pathArgs) {
    return _wrapper(request, response, pathArgs, () async {
      //! here just start verifying the email
      String? jwt = pathArgs[PathFields.jwt];
      if (jwt == null) {
        throw RequestBodyError('jwt can\'t be empty');
      }

      await authService.markUserVerified(jwt);
      return SendResponse.sendDataToUser(
        response,
        'Email verified successfully',
      );
    });
  }

  @override
  FutureOr<PassedHttpEntity> changePassword(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var body = await request.readAsJson();
      String? email = body[ModelFields.email];
      String? oldPassword = body[BodyFields.oldPassword];
      String? newPassword = body[BodyFields.newPassword];
      if (email == null || oldPassword == null || newPassword == null) {
        throw RequestBodyError(
            'email && oldPassword && newPassword can\'t be empty');
      }

      await authService.changePassword(
        email,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return SendResponse.sendDataToUser(response, 'password changed!');
    });
  }

  @override
  FutureOr<PassedHttpEntity> deleteUserData(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      String? id = request.context[ContextFields.userId];
      if (id == null) {
        throw RequestBodyError('id is null');
      }
      try {
        await authService.deleteUserData(id);
      } catch (e) {
        throw Exception('can\'t delete user data id=$id');
      }
      return SendResponse.sendDataToUser(response, 'user data deleted');
    });
  }

  @override
  FutureOr<PassedHttpEntity> forgetPassword(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    // TODO: implement forgetPassword
    throw UnimplementedError();
  }

  @override
  FutureOr<PassedHttpEntity> fullyDeleteUser(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      String? id = request.context[ContextFields.userId];
      if (id == null) {
        throw RequestBodyError('id can\'t be null');
      }
      try {
        await authService.fullyDeleteUser(id);
      } catch (e) {
        throw Exception('can\'t delete full user data id=$id');
      }
      return SendResponse.sendDataToUser(response, 'full user data deleted');
    });
  }

  @override
  FutureOr<PassedHttpEntity> logout(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    // TODO: implement logout
    throw UnimplementedError();
  }

  //? this method will require the user to be logged in
  //! make another endpoint for not logged in users which will accept the user email and password then logging out from all devices
  @override
  FutureOr<PassedHttpEntity> logoutFromAllDevices(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      String? id = request.context[ContextFields.userId];
      if (id == null) {
        throw RequestBodyError('id can\'t be null');
      }
      try {
        await authService.logoutFromAllDevices(id);
      } catch (e) {
        throw Exception('can\'t log out from all devices id=$id');
      }
      return SendResponse.sendDataToUser(
          response, 'logged out from all devices');
    });
  }

  @override
  FutureOr<PassedHttpEntity> updateUserData(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var body = await request.readAsJson();
      String? id = request.context[ContextFields.userId];
      Map<String, dynamic> updateDoc;
      try {
        updateDoc = json.decode(body[BodyFields.updateDoc]);
      } catch (e) {
        throw RequestBodyError(
            'you must provided updateDoc with the user data needed to be updated at the form of Map<String, dynamic>');
      }

      if (id == null) {
        throw RequestBodyError('id can\'t be null');
      }
      try {
        await authService.updateUserData(id, updateDoc);
      } catch (e) {
        throw Exception('can\'t update user data id=$id');
      }
      return SendResponse.sendDataToUser(
          response, 'user data updated successfully');
    });
  }
}

Message getEmailVerificationMessage({
  required String mailTo,
  required String from,
  String? subject,
}) {
  return Message()
    ..recipients.add(mailTo)
    ..bccRecipients.add(mailTo)
    ..subject = subject ?? 'Email Verification'
    ..from = from;
}
