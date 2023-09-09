import 'package:json_annotation/json_annotation.dart';

class ApiKeyModel {
  final String name;
  final String apiKey;
  final DateTime createdAt;

  /// this can be null, to add the option to lifetime api keys
  final Duration? expireAfter;

  const ApiKeyModel({
    required this.name,
    required this.apiKey,
    required this.createdAt,
    required this.expireAfter,
  });

  String toQuery() {
    String createdAtString = createdAt.toIso8601String();
    String? expiryDateString = expireAfter?.inSeconds.toString();
    String expiryDateFinal =
        expiryDateString == null ? '' : '|$expiryDateString';
    String fullQuery = '$name|$apiKey|$createdAtString$expiryDateFinal';
    return fullQuery;
  }

  static ApiKeyModel fromQuery(String query) {
    Duration? expiryDate;
    List<String> parts = query.split('|');
    if (parts.length == 4) {
      expiryDate = Duration(seconds: int.parse(parts[3]));
    }
    String name = parts[0];
    String apiKey = parts[1];
    DateTime createdAt = DateTime.parse(parts[2]);
    ApiKeyModel model = ApiKeyModel(
      name: name,
      apiKey: apiKey,
      createdAt: createdAt,
      expireAfter: expiryDate,
    );
    return model;
  }

  bool get expired {
    Duration? date = expireAfter;
    if (date == null) {
      return false;
    }
    // checking for expiration
    DateTime now = DateTime.now();
    Duration diff = now.difference(createdAt);
    int diffMicro = diff.inSeconds;
    int allowanceMicro = date.inSeconds;
    bool expire = diffMicro > allowanceMicro;
    return expire;
  }
}

class DateConverter extends JsonConverter<DateTime, String> {
  const DateConverter();
  @override
  DateTime fromJson(String json) {
    return DateTime.parse(json);
  }

  @override
  String toJson(DateTime object) {
    return object.toIso8601String();
  }
}
