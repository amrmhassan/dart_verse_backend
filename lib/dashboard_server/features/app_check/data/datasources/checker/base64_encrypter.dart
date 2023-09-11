import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Base64Encrypter {
  final String encrypterSecretKey;

  const Base64Encrypter(this.encrypterSecretKey);

  String? _executer(String content, bool encode) {
    try {
      final originalSecretKey = encrypterSecretKey;

      final hashedKeyBytes = Uint8List.fromList(
        sha256.convert(utf8.encode(originalSecretKey)).bytes,
      );

      final aesSecretKey = Key(Uint8List.sublistView(hashedKeyBytes, 0, 16));
      final iv = IV.fromLength(16);
      final encrypter = Encrypter(AES(aesSecretKey));

      if (encode) {
        final encryptedContent = encrypter.encrypt(content, iv: iv);
        return encryptedContent.base64;
      } else {
        final encrypted = Encrypted.fromBase64(content);
        final decrypted = encrypter.decrypt(encrypted, iv: iv);
        return decrypted;
      }
    } catch (e) {
      return null;
    }
  }

  String? encrypt(String text) {
    return _executer(text, true);
  }

  String? decrypt(String base64String) {
    return _executer(base64String, false);
  }
}
