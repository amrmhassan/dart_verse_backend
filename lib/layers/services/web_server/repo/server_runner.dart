import 'dart:io';

import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/entities/http_server_setting.dart';
import 'package:dart_webcore/dart_webcore.dart';

class ServerRunner {
  final App _app;
  final Pipeline _pipeline;
  late ServerHolder _serverHolder;

  ServerRunner(this._app, this._pipeline) {
    _serverHolder = ServerHolder(_pipeline);
  }
  ServerHolder get serverHolder => _serverHolder;

  /// this will return the mainServer instance only
  Future<void> run() async {
    HttpServerSetting mainServerSettings =
        _app.serverSettings.mainServerSettings;
    HttpServerSetting dashboardServerSettings =
        _app.serverSettings.dashboardServerSettings;
    await _runServer(mainServerSettings);
    await _runServer(dashboardServerSettings);
  }

  Future<HttpServer> _runServer(HttpServerSetting setting) async {
    SecurityContext? context = setting.context;
    if (context == null) {
      // run the non secured server
      return _runNonSecuredServer(setting);
    } else {
      // run the secured server
      return _runSecuredServer(setting);
    }
  }

  Future<HttpServer> _runSecuredServer(HttpServerSetting setting) async {
    return _serverHolder.bindSecure(
      setting.address,
      setting.port,
      setting.context!,
      backlog: setting.backlog,
      shared: setting.shared,
      v6Only: setting.v6Only,
    );
  }

  Future<HttpServer> _runNonSecuredServer(HttpServerSetting setting) async {
    return _serverHolder.bind(
      setting.address,
      setting.port,
      backlog: setting.backlog,
      shared: setting.shared,
      v6Only: setting.v6Only,
    );
  }
}
