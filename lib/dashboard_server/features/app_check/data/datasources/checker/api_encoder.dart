import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'base64_encrypter.dart';
import 'hmac_handler.dart';

class ApiEncoder {
  final String secretKey;
  final String encrypterSecretKey;
  late Base64Encrypter _encrypter;
  late HmacHandler _hmacHandler;

  ApiEncoder({
    required this.secretKey,
    required this.encrypterSecretKey,
  }) {
    _encrypter = Base64Encrypter(encrypterSecretKey);
    _hmacHandler = HmacHandler(secretKey);
  }

  String encoded(String api) {
    String id = Uuid().v4();
    String timestamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    String message = '$timestamp$api$id';
    String hmac = _hmacHandler.generateHmacSignature(message);
    Map<String, String> dataObj = {
      'api': api,
      'id': id,
      'hmac': hmac,
      'timestamp': timestamp,
    };
    String messageToEncrypt = json.encode(dataObj);
    String? encryptedMessage = _encryptString(messageToEncrypt);
    if (encryptedMessage == null) {
      throw Exception(
          'the encrypted message is equal to null and this is not accepted');
    }
    return encryptedMessage;
  }

  String? _encryptString(String text) {
    return _encrypter.encrypt(text);
  }
}
