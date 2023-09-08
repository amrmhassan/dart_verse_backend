import 'dart:convert';

import 'base64_encrypter.dart';
import 'hmac_handler.dart';

class ApiDecoder {
  final String secretKey;
  final String encrypterSecretKey;
  late Base64Encrypter _encrypter;
  late HmacHandler _hmacHandler;

  ApiDecoder({
    required this.secretKey,
    required this.encrypterSecretKey,
  }) {
    _encrypter = Base64Encrypter(encrypterSecretKey);
    _hmacHandler = HmacHandler(secretKey);
  }

  String? getValidApi(String? base64Encoded) {
    if (base64Encoded == null) return null;
    String? jsonObjString = _decryptString(base64Encoded);
    if (jsonObjString == null) return null;
    Map<String, dynamic> jsonObj = json.decode(jsonObjString);
    String? api = jsonObj['api'];
    String? id = jsonObj['id'];
    String? timestamp = jsonObj['timestamp'];
    String? hmac = jsonObj['hmac'];
    if (api == null || id == null || timestamp == null || hmac == null) {
      return null;
    }

    // here all  the data are available
    String message = '$timestamp$api$id';
    String generatedHmac = _hmacHandler.generateHmacSignature(message);
    bool validHash = generatedHmac == hmac;
    if (!validHash) {
      return null;
    }
    return api;
  }

  String? _decryptString(String base64Encoded) {
    return _encrypter.decrypt(base64Encoded);
  }
}
