import 'package:json_annotation/json_annotation.dart';
part 'api_key_model.g.dart';

@JsonSerializable(explicitToJson: true)
@DateConverter()
class ApiKeyModel {
  final String name;
  final String apiKey;
  final DateTime createdAt;

  /// this can be null, to add the option to lifetime api keys
  final DateTime? expiryDate;

  const ApiKeyModel({
    required this.name,
    required this.apiKey,
    required this.createdAt,
    required this.expiryDate,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiKeyModelToJson(this);

  String toQuery() {
    String createdAtString = createdAt.toIso8601String();
    String? expiryDateString = expiryDate?.toIso8601String();
    String expiryDateFinal =
        expiryDateString == null ? '' : '|$expiryDateString';
    String fullQuery = '$name|$apiKey|$createdAtString$expiryDateFinal';
    return fullQuery;
  }

  static ApiKeyModel fromQuery(String query) {
    DateTime? expiryDate;
    List<String> parts = query.split('|');
    if (parts.length == 4) {
      expiryDate = DateTime.parse(parts[3]);
    }
    String name = parts[0];
    String apiKey = parts[1];
    DateTime createdAt = DateTime.parse(parts[2]);
    ApiKeyModel model = ApiKeyModel(
      name: name,
      apiKey: apiKey,
      createdAt: createdAt,
      expiryDate: expiryDate,
    );
    return model;
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
