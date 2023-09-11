import 'package:dart_verse_backend/constants/reserved_keys.dart';

class ModelFields {
  static const String name = 'name';
  static const String email = 'email';
  static const String id = '_id';
  static const String password = 'password';
  static const String passwordHash = 'passwordHash';
  static const String activeTokens = 'activeTokens';

  //? db fields name
}

class DbFields {
  static const String verified = 'verified';
  static const String verificationJWT = 'verificationJWT';
  static const String id = DBRKeys.id;
}
