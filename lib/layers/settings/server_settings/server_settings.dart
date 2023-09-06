import 'package:dart_verse_backend/layers/settings/server_settings/entities/dashboard_server_settings.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/entities/http_server_setting.dart';

class ServerSettings {
  final HttpServerSetting mainServerSettings;
  final HttpServerSetting dashboardServerSettings;
  final DashboardSettings dashboardSettings;

  ServerSettings({
    required this.mainServerSettings,
    required this.dashboardServerSettings,
    required this.dashboardSettings,
  });
}
