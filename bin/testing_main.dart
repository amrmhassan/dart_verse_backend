import 'package:dart_verse_backend/features/cred_auth/repo/auth_with_cred.dart';

String clientID =
    '584766071015-iu6e6lq65rji5a140ptbiib7lt0187qj.apps.googleusercontent.com';
String clientSecret = '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';
void main(List<String> args) async {
  AuthWithGoogle authWithGoogle = AuthWithGoogle(
    clientId: clientID,
    clientSecret: clientSecret,
    redirectUrl: 'http://localhost:3000',
  );
  authWithGoogle.run();
}
