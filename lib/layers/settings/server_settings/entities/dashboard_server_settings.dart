import 'package:dart_verse_backend/layers/settings/db_settings/repo/conn_link.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/entities/http_server_setting.dart';

class DashboardSettings {
  final MongoDbConnLink dashboardConnLink;
  final HttpServerSetting dashboardServerSettings;

  const DashboardSettings({
    required this.dashboardConnLink,
    required this.dashboardServerSettings,
  });
}
