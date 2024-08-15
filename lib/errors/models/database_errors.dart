// ignore_for_file: overridden_fields

import 'package:dart_verse_backend_new/errors/serverless_exception.dart';

import 'package:dart_verse_backend_new/constants/error_codes.dart';

class DBException extends ServerLessException {
  @override
  String message;
  @override
  String code;
  DBException(this.message, this.code) : super(code);
}

//? db exceptions
class DBReadException extends DBException {
  @override
  String message;

  DBReadException(this.message)
      : super(
          message,
          ErrorCodes.dbReadCode,
        );
}

class DBWriteException extends DBException {
  @override
  String message;

  DBWriteException(this.message)
      : super(
          message,
          ErrorCodes.dbWriteCode,
        );
}

class DBDeleteException extends DBException {
  @override
  String message;

  DBDeleteException(this.message)
      : super(
          message,
          ErrorCodes.dbDeleteCode,
        );
}

class DbDocValidationException extends DBException {
  @override
  String message;

  DbDocValidationException(this.message)
      : super(
          message,
          ErrorCodes.dbDocValidation,
        );
}

class MongoDbNotInitializedYet extends DBException {
  MongoDbNotInitializedYet()
      : super(
          'mongo db not initialized yet',
          ErrorCodes.mongoDbNotInitialized,
        );
}

class DbNotConnectedException extends DBException {
  DbNotConnectedException()
      : super(
          'db not connected yet, please run dbService.connectToDb()',
          ErrorCodes.dbNotConnoted,
        );
}

class DbAlreadyConnectedException extends DBException {
  DbAlreadyConnectedException()
      : super(
          'db already connected before.',
          ErrorCodes.dbAlreadyConnoted,
        );
}

class DocNotFoundException extends DBException {
  DocNotFoundException(String docId)
      : super(
          'the doc with id $docId not found',
          ErrorCodes.docNotFound,
        );
}

class MongoDbNotConnectedException extends DBException {
  MongoDbNotConnectedException()
      : super(
          'mongo db not connected exception',
          ErrorCodes.mongoDbNotConnected,
        );
}
