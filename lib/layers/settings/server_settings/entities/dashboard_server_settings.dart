import 'package:dart_verse_backend/layers/settings/db_settings/repo/conn_link.dart';

class DashboardSettings {
  final MongoDbConnLink dashboardConnLink;

  const DashboardSettings(this.dashboardConnLink);
}
