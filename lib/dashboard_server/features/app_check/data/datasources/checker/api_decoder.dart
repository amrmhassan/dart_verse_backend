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

  ApiKeyData? getValidApi(String? base64Encoded) {
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

    DateTime createdAt =
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    // here all  the data are available
    String message = '$timestamp$api$id';
    String generatedHmac = _hmacHandler.generateHmacSignature(message);
    bool validHash = generatedHmac == hmac;
    if (!validHash) {
      return null;
    }
    var apiData = ApiKeyData(api: api, createdAt: createdAt, id: id);
    return apiData;
  }

  String? _decryptString(String base64Encoded) {
    return _encrypter.decrypt(base64Encoded);
  }
}

class ApiKeyData {
  final String api;
  final DateTime createdAt;
  final String id;

  const ApiKeyData({
    required this.api,
    required this.createdAt,
    required this.id,
  });
}
