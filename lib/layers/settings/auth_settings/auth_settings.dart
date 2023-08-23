import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse_backend/layers/settings/defaults/default_auth_settings.dart';

class AuthSettings {
  /// this is the collection name of the auth table(collection) that you want to save users auth info in
  final String collectionName;

  /// this will be used to allow duplicate emails so you can use multi providers(facebook, email, google, etc...)
  final bool allowDuplicateEmails;

  /// the jwt will expire after this duration so the user must login again for a new jwt
  final Duration authExpireAfter;

  /// this is the jwt secret key  `[Must be stored in a safe place]`
  final JWTKey jwtSecretKey;

  /// this is the algorithm used to deal with the jwt
  final JWTAlgorithm jwtAlgorithm;

  /// this is the collection name for the active tokens of the user to keep track of all user sessions
  final String activeJWTCollName;

  /// this will define how many times user can login while there is another active jwt to be used
  /// to prevent so many creations of jwts
  final int maximumActiveJwts;

  /// this will restrict the usage of your endpoints on some apps
  /// that will provide app id in all request headers
  /// on the format headerKey = appid, and with value of the app id
  final List<String>? allowedAppsIds;

  const AuthSettings({
    required this.jwtSecretKey,
    this.collectionName = DefaultAuthSettings.collectionName,
    this.allowDuplicateEmails = DefaultAuthSettings.allowDuplicateEmails,
    this.authExpireAfter = DefaultAuthSettings.authExpireAfter,
    this.activeJWTCollName = DefaultAuthSettings.activeTokensCollName,
    this.maximumActiveJwts = 5,
    this.jwtAlgorithm = JWTAlgorithm.HS256,
    this.allowedAppsIds,
  });
}
