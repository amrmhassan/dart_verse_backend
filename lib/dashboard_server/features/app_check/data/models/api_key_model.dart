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
}
