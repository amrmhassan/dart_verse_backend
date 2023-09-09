import 'package:json_annotation/json_annotation.dart';
part 'api_key_model.g.dart';

@JsonSerializable(explicitToJson: true)
@DateConverter()
class ApiKeyModel {
  final String id;
  final String name;
  final String apiKey;
  final DateTime createdAt;

  /// this can be null, to add the option to lifetime api keys
  final DateTime? expiryDate;

  const ApiKeyModel({
    required this.id,
    required this.name,
    required this.apiKey,
    required this.createdAt,
    required this.expiryDate,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) =>
      _$ApiKeyModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiKeyModelToJson(this);
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
