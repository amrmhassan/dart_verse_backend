import 'package:dart_verse_backend/layers/settings/server_settings/entities/http_server_setting.dart';

class ServerSettings {
  final HttpServerSetting mainServerSettings;
  final HttpServerSetting dashboardServerSettings;

  ServerSettings({
    required this.mainServerSettings,
    required this.dashboardServerSettings,
  });
}
