// ignore_for_file: overridden_fields

import 'package:dart_verse/constants/error_codes.dart';

import '../serverless_exception.dart';

class EmailException extends ServerLessException {
  @override
  String message;
  @override
  final String code;

  EmailException(this.message, this.code) : super(code);
}

//? email exceptions
class TemplateNotFoundException extends EmailException {
  TemplateNotFoundException()
      : super(
          'email template not found',
          ErrorCodes.emailTemplateFileNotFound,
        );
}
