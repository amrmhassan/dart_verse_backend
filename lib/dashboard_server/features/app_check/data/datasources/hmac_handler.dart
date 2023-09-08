import 'dart:convert';

import 'package:crypto/crypto.dart';

class HmacHandler {
  final String secretKey;

  const HmacHandler(this.secretKey);

  String generateHmacSignature(String message) {
    // String derivedKey = deriveKeyFromSecret(secretKey);
    final key = utf8.encode(secretKey);
    final bytes = utf8.encode(message);
    final hmac = Hmac(sha256, key); // Use SHA-256 for HMAC
    final digest = hmac.convert(bytes);
    return digest.toString();
  }
}
