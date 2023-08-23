import 'dart:convert';
import 'dart:io';

class ReqTrans {
  static Future<dynamic> decodeRequest(
    HttpRequest request, [
    bool jsonify = true,
  ]) async {
    try {
      String requestBody = await utf8.decoder.bind(request).join();
      if (jsonify) {
        var jsonData = json.decode(requestBody);

        return jsonData;
      }
      return requestBody;
    } catch (e) {
      return null;
    }
  }

  static String jsonify(Map<String, dynamic> obj) {
    return json.encode(obj);
  }

  static List<int> encodeRequest(dynamic data) {
    return utf8.encode(data);
  }
}
