import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/datasources/api_key_generator.dart';

List<String> apiKeys = [];
void main(List<String> args) async {
  ApiKeyGenerator generator =
      ApiKeyGenerator(encrypterSecretKey: 'encrypterSecretKey');
  for (var i = 0; i < 1000; i++) {
    String apiKey = generator.generateApiKey('Shiaka', expireAfter: null);
    if (apiKeys.contains(apiKey)) {
      throw Exception('This api key already exists');
    }
    apiKeys.add(apiKey);
    print(apiKey);
  }
  print(apiKeys.length);
}
