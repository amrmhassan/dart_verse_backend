import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/check_app_datasource.dart';

class AppCheck {
  final String secretKey;
  final String encrypterSecretKey;
  final Duration apiHashExpiryAfter;
  late CheckAppDatasource checkAppDatasource;

  AppCheck({
    required this.secretKey,
    required this.encrypterSecretKey,
    required this.apiHashExpiryAfter,
  }) {
    checkAppDatasource = CheckAppDatasource(
      secretKey: secretKey,
      encrypterSecretKey: encrypterSecretKey,
      apiHashExpiryAfter: apiHashExpiryAfter,
    );
  }

  Future<void> validateApiHash(String? apiHash) async {
    await checkAppDatasource.validateApiHash(apiHash);
  }
}
