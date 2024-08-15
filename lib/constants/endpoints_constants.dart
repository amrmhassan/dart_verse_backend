import 'package:dart_verse_backend_new/constants/path_fields.dart';

class EndpointsConstants {
  // server
  static const String serverAlive = '/checkServerAlive';
  static const String serverTime = '/getServerTime';

  // auth
  static const String login = '/login';
  static const String register = '/register';
  static const String verifyEmail = '/verifyEmail';
  static const String getVerificationEmail = '/getVerificationEmail';
  static const String changePassword = '/changePassword';
  static const String forgetPassword = '/forgetPassword';
  static const String logoutFromAllDevices = '/logoutFromAllDevices';
  static const String logout = '/logout';
  static const String updateUserData = '/updateUserData';
  static const String deleteUserData = '/deleteUserData';
  static const String fullyDeleteUser = '/fullyDeleteUser';

  // storage
  static const String uploadFile = '/upload';
  static const String downloadFile =
      '/download/<${PathFields.bucketName}>/*<${PathFields.filePath}>';
  static const String deleteFile = '/delete';
  static const String listChildren = '/listChildren';

  // db
  static const String getDbConnLink = '/getDbConnLink';
  // apis control
  static const String listApiKeys = '/listApiKeys';
  static const String listApiHashes = '/listApiHashes';
  static const String generateApiKey = '/generateApiKey';
  static const String deleteApiKey = '/deleteApiKey';
  static const String toggleApiKeyActiveness = '/toggleApiKeyActiveness';
  static const String apiSecretDecryption = '/apiSecretDecryption';
}
