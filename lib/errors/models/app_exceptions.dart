// ignore_for_file: overridden_fields

import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/constants/error_codes.dart';

class AppExceptions extends ServerLessException {
  String _message;

  @override
  final String code;

  AppExceptions(this._message, this.code) : super(code);
  @override
  String get message => _message;

  @override
  set message(String value) => _message = value;
}

//? app exceptions
class NoDbSettingsExceptions extends AppExceptions {
  NoDbSettingsExceptions()
      : super(
          'please provide DBSettings if you wanna use db',
          ErrorCodes.noDbSettingsCode,
        );
}

class NoMongoDbProviderExceptions extends AppExceptions {
  NoMongoDbProviderExceptions()
      : super(
          'no mongo db provider, please add one to db settings',
          ErrorCodes.noMongoDbProvider,
        );
}

class NoMemoryDbProviderExceptions extends AppExceptions {
  NoMemoryDbProviderExceptions()
      : super(
          'no memory db provider, please add one to db settings',
          ErrorCodes.noMemoryDbProvider,
        );
}

class NoAuthSettings extends AppExceptions {
  NoAuthSettings()
      : super(
          'please provider authSettings to the app',
          ErrorCodes.noAuthSettings,
        );
}

class NoServerSettingsExceptions extends AppExceptions {
  NoServerSettingsExceptions()
      : super(
          'no serverSettings provided',
          ErrorCodes.noServerSettings,
        );
}

class NoUserDataSettingsException extends AppExceptions {
  NoUserDataSettingsException()
      : super(
          'no user data settings provided, please add UserDataSettings to the app',
          ErrorCodes.noUserDataSettings,
        );
}

class NoEmailSettingsException extends AppExceptions {
  NoEmailSettingsException()
      : super(
          'no email settings provided, please add EmailSettings to the app',
          ErrorCodes.noUserDataSettings,
        );
}
