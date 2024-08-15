import 'dart:async';
import 'dart:io';
import 'package:dart_verse_backend_new/dashboard_server/dashboard.dart';
import 'package:dart_verse_backend_new/dashboard_server/features/app_check/server/app_check_middleware.dart';
import 'package:dart_verse_backend_new/layers/service_server/auth_server/auth_server.dart';
import 'package:dart_verse_backend_new/layers/service_server/auth_server/repo/auth_server_settings.dart';
import 'package:dart_verse_backend_new/layers/service_server/db_server/db_server.dart';
import 'package:dart_verse_backend_new/layers/service_server/service_server.dart';
import 'package:dart_verse_backend_new/layers/service_server/storage_server/storage_server.dart';
import 'package:dart_verse_backend_new/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend_new/layers/services/web_server/datasource/server_handlers.dart';
import 'package:dart_verse_backend_new/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend_new/layers/services/web_server/repo/server_runner.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

FutureOr<PassedHttpEntity> _corsMiddleWare(
  request,
  ResponseHolder response,
  pathArgs,
) async {
  // Enable CORS by setting the necessary headers
  request.response.headers.add(HttpHeaders.accessControlAllowOriginHeader, '*');
  request.response.headers
      .add(HttpHeaders.accessControlAllowMethodsHeader, '*');
  request.response.headers
      .add(HttpHeaders.accessControlAllowHeadersHeader, '*');

  // Handle preflight request (OPTIONS)
  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;

    await response.close();
    return response;
  }
  return request;
}

//! move handlers  of the auth service to a middle step between the authService and serverService
//! you can call this step serverAuth
//! and for the storage service you can add a step called serverStorage
class ServerService {
  final App app;
  final AuthServerSettings authServerSettings;
  final DbService dbService;
  late Dashboard _dashboard;
  final bool disableCORS;

  ServerService(
    this.app, {
    required this.authServerSettings,
    required this.dbService,
    this.disableCORS = false,
  }) {
    _pipeline = Pipeline();
    serverRunner = ServerRunner(
      app,
      _pipeline,
      disableCORS: disableCORS,
    );
    if (app.dashboardSettings != null) {
      _dashboard = Dashboard(app.dashboardSettings!, app);
    }
  }

  late Pipeline _pipeline;
  late ServerRunner serverRunner;

  Future<void> runServers({
    bool log = false,
    AuthServer? authServer,
    StorageServer? storageServer,
    DBServer? dbServer,
  }) async {
    serverRunner.serverHolder.addGlobalMiddleware(logRequest);

    _addServicesEndpoints(
      authServer: authServer,
      dbServer: dbServer,
      storageServer: storageServer,
    );
    await _addAppCheck();
    return serverRunner.run();
  }

  ServerService addRouter(RouterInfo routerInfo) {
    bool jwtSecured = routerInfo.jwtSecured;
    bool emailMustBeVerified = routerInfo.emailMustBeVerified;
    Router router = routerInfo.router;
    if (disableCORS) {
      router.addUpperMiddleware(null, HttpMethods.all, _corsMiddleWare);
    }
    // this middleware will check for db auto reconnecting
    router.addUpperMiddleware(null, HttpMethods.all,
        (request, response, pathArgs) async {
      if (dbService.connected) return request;
      await dbService.reconnect();

      return request;
    });

    //? run checks here
    if (!jwtSecured && emailMustBeVerified) {
      throw Exception(
          'emailMustBeVerified && !jwtSecured, to check if email must be verified user must be logged in first');
    }

    //? adding middlewares here
    // checking for app id for every

    // checking if jwt is added and user logged in
    if (jwtSecured) {
      router
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtInHeaders,
            signature: 'checkJwtInHeadersFromUserCustomRoutes',
          )
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtForUserId,
            signature: 'checkJwtForUserId',
          );
    }
    // checking if email is verified
    if (emailMustBeVerified) {
      router.addUpperMiddleware(
        null,
        HttpMethods.all,
        authServerSettings.authServerMiddlewares.checkUserEmailVerified,
      );
    }

    //?

    _pipeline = _pipeline.addRouter(router);
    return this;
  }

  Pipeline get pipeline {
    return _pipeline;
  }

  void _addServicesEndpoints({
    AuthServer? authServer,
    StorageServer? storageServer,
    DBServer? dbServer,
  }) {
    ServerHandlers serverHandlers = ServerHandlers();
    // adding server check router
    addRouter(serverHandlers.getServerRouter());

    // adding services servers
    _addServerService(authServer);
    _addServerService(storageServer);
    _addServerService(dbServer);
  }

  void _addServerService(ServiceServerLayer? layer) {
    if (layer == null) return;
    var routersInfo = layer.addRouters();
    for (var routerInfo in routersInfo) {
      addRouter(routerInfo);
    }
  }

  Future<void> _addAppCheck() async {
    if (app.dashboardSettings != null) {
      await _dashboard.run();
      if (app.dashboardSettings?.appCheckSettings != null) {
        AppCheckMiddleware middleware =
            AppCheckMiddleware(app, _dashboard.dbService);
        serverRunner.serverHolder.addGlobalMiddleware(middleware.checkApp);
      }
    }
  }
}
