import 'package:dart_verse_backend/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse_backend/layers/services/auth/auth_service.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/repo/auth_middlewares.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/repo/auth_server_handlers.dart';

abstract class AuthServerSettings {
  late AuthServerHandlers authServerHandlers;
  // late AuthBodyKeys authBodyKeys;
  late AuthServerMiddlewares authServerMiddlewares;
  late EmailVerificationProvider emailVerificationProvider;

  late AuthService authService;

  // /// this is the host of your backend and the port  <br>
  // /// if you are running it local make it http://localhost don't enter the port  <br>
  // /// must be on the format scheme://host example: https://example.com  <br>
  // /// this will be used in emails to send to the user  <br>
  // late String backendHost;
}
