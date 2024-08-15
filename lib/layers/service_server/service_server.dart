import 'package:dart_verse_backend_new/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';

abstract class ServiceServerLayer {
  late App app;
  List<RouterInfo> addRouters();
}
