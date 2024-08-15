import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/datasources/check_app_datasource.dart';
import 'package:dart_verse_backend_new/layers/services/db_manager/db_service.dart';

class AppCheck {
  final String _encrypterSecretKey;

  /// this is the time to un validate the api hash generated on the client side
  /// it has nothing to do with expiring the api hash from the database
  /// it should be small, like 2 seconds or so, depending on the client-server internet speed
  /// because after that period the request sent from the client will be invalid and will be rejected

  final Duration _clientApiAllowance;
  late CheckAppDatasource _checkAppDatasource;
  final DbService _dbService;

  AppCheck({
    required String encrypterSecretKey,
    required Duration clientApiAllowance,
    required DbService dbService,
  })  : _dbService = dbService,
        _clientApiAllowance = clientApiAllowance,
        _encrypterSecretKey = encrypterSecretKey {
    _checkAppDatasource = CheckAppDatasource(
      encrypterSecretKey: _encrypterSecretKey,
      apiHashExpiryAfter: _clientApiAllowance,
      dbService: _dbService,
    );
  }

  Future<void> validateApiHash(String apiKey, String? apiHash) async {
    await _checkAppDatasource.validateApiHash(apiKey, apiHash);
  }
}
