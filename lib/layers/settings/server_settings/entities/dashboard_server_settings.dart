import 'package:dart_verse_backend_new/layers/settings/db_settings/repo/conn_link.dart';
import 'package:dart_verse_backend_new/layers/settings/server_settings/entities/http_server_setting.dart';

class DashboardSettings {
  final MongoDbConnLink dashboardConnLink;
  final HttpServerSetting dashboardServerSettings;
  final AppCheckSettings? appCheckSettings;

  const DashboardSettings({
    required this.dashboardConnLink,
    required this.dashboardServerSettings,
    this.appCheckSettings,
  });
}

class AppCheckSettings {
  final String encrypterSecretKey;
  final Duration clientApiAllowance;
  const AppCheckSettings({
    required this.clientApiAllowance,
    required this.encrypterSecretKey,
  });
}
