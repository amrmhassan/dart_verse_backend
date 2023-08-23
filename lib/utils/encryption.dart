import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';

class Encryption {
  final String _secretKey;
  late Encrypter _encrypter;
  late IV _iv;

  Encryption(this._secretKey) {
    String keyString = sha256.convert(utf8.encode(_secretKey)).toString();
    final keyE = Key.fromUtf8(keyString.substring(0, 32));
    _iv = IV.fromLength(16);
    _encrypter = Encrypter(AES(keyE, mode: AESMode.cbc));
  }

  Encrypted encrypt(String content) {
    return _encrypter.encrypt(content, iv: _iv);
  }

  String decrypt(Uint8List bytes) {
    return _encrypter.decrypt(Encrypted(bytes), iv: _iv);
  }

  File encryptAndSave(String content, String filePath) {
    var encrypted = encrypt(content);
    File file = File(filePath);
    file.writeAsBytesSync(encrypted.bytes);
    return file;
  }

  String? readEncryptedFile(String filePath) {
    File file = File(filePath);
    if (!file.existsSync()) return null;
    var bytes = file.readAsBytesSync();
    return decrypt(bytes);
  }
}
