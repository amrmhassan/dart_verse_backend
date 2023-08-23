// ignore_for_file: overridden_fields

import 'package:dart_verse/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse/layers/services/auth/auth_service.dart';

class DefaultEmailVerificationProvider extends EmailVerificationProvider {
  @override
  String? emailTemplate;
  @override
  Duration? verifyLinkExpiresAfter;
  @override
  final Duration? allowNewVerificationEmailAfter;

  @override
  AuthService authService;

  DefaultEmailVerificationProvider({
    this.emailTemplate,
    this.verifyLinkExpiresAfter,
    this.allowNewVerificationEmailAfter,
    required this.authService,
  }) : super(
          emailTemplate: emailTemplate,
          verifyLinkExpiresAfter: verifyLinkExpiresAfter,
          authService: authService,
          allowNewVerificationEmailAfter: allowNewVerificationEmailAfter,
        );
}
