import 'dart:io';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:dart_verse_backend_new/layers/settings/server_settings/entities/http_server_setting.dart';
import 'package:dart_webcore/dart_webcore.dart';

class ServerRunner {
  final App _app;
  final Pipeline _pipeline;
  late ServerHolder _serverHolder;
  final bool disableCORS;

  ServerRunner(
    this._app,
    this._pipeline, {
    required this.disableCORS,
  }) {
    _serverHolder = ServerHolder(
      _pipeline,
      onPathNotFound: (request, response, pathArgs) {
        if (disableCORS && request.request.method.toLowerCase() == 'options') {
          request.response.headers.add('Access-Control-Allow-Origin', '*');
          request.response.headers.add('Access-Control-Allow-Methods',
              'GET, POST, PUT, DELETE, OPTIONS');
          request.response.headers.add('Access-Control-Allow-Headers',
              'Origin, X-Requested-With, Content-Type, Accept');
          return response
            ..write('CORS disabled', code: HttpStatus.noContent)
            ..close();
        } else {
          return response
            ..write('Path Not Found')
            ..close();
        }
      },
    );
  }

  /// this is the main server helper
  ServerHolder get serverHolder => _serverHolder;

  /// this will return the mainServer instance only
  Future<void> run() async {
    HttpServerSetting mainServerSettings = _app.mainServerSettings;
    await _runServer(mainServerSettings, _serverHolder);
  }

  Future<HttpServer> _runServer(
    HttpServerSetting setting,
    ServerHolder serverHolder,
  ) async {
    SecurityContext? context = setting.context;
    if (context == null) {
      // run the non secured server
      return _runNonSecuredServer(setting, serverHolder);
    } else {
      // run the secured server
      return _runSecuredServer(setting, serverHolder);
    }
  }

  Future<HttpServer> _runSecuredServer(
    HttpServerSetting setting,
    ServerHolder serverHolder,
  ) async {
    return serverHolder.bindSecure(
      setting.address,
      setting.port,
      setting.context!,
      backlog: setting.backlog,
      shared: setting.shared,
      v6Only: setting.v6Only,
      afterServerMessage: (protocol, address, port) {
        return 'listening on $protocol://$address:$port for App ${_app.appName}';
      },
    );
  }

  Future<HttpServer> _runNonSecuredServer(
    HttpServerSetting setting,
    ServerHolder serverHolder,
  ) async {
    return serverHolder.bind(
      setting.address,
      setting.port,
      backlog: setting.backlog,
      shared: setting.shared,
      v6Only: setting.v6Only,
      afterServerMessage: (protocol, address, port) {
        return 'listening on $protocol://$address:$port for App ${_app.appName}';
      },
    );
  }
}
