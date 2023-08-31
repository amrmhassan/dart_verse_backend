import 'package:dart_verse_backend/layers/services/web_server/server_service.dart';

abstract class ServiceServerLayer {
  late ServerService serverService;
  void addRouters();
}
