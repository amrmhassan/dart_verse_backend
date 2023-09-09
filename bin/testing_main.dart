import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';

List<String> apiKeys = [];
void main(List<String> args) async {
  ApiKeyGenerator generator = ApiKeyGenerator(
      datasource: null, encrypterSecretKey: 'encrypterSecretKey');
  for (var i = 0; i < 1000; i++) {
    String apiKey = generator.generateApiKey('Shiaka');
    if (apiKeys.contains(apiKey)) {
      throw Exception('This api key already exists');
    }
    apiKeys.add(apiKey);
    print(apiKey);
  }
  print(apiKeys.length);
}
