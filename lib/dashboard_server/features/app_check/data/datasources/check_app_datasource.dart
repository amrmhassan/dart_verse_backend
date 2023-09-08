import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/checker/api_decoder.dart';

List<String> allowedAppIds = ['This is the encrypter key'];

class CheckAppDatasource {
  final String secretKey;
  final String encrypterSecretKey;

  const CheckAppDatasource({
    required this.secretKey,
    required this.encrypterSecretKey,
  });

  String? getApiFromHash(String apiHash) {
    ApiDecoder decoder = ApiDecoder(
      secretKey: secretKey,
      encrypterSecretKey: encrypterSecretKey,
    );
    String? validApi = decoder.getValidApi(apiHash);
    return validApi;
  }
}
