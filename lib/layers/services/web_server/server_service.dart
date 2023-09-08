import 'dart:async';
import 'package:dart_verse_backend/constants/endpoints_constants.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/auth_server.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/repo/auth_server_settings.dart';
import 'package:dart_verse_backend/layers/service_server/db_server/db_server.dart';
import 'package:dart_verse_backend/layers/service_server/service_server.dart';
import 'package:dart_verse_backend/layers/service_server/storage_server/storage_server.dart';
import 'package:dart_verse_backend/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend/layers/services/web_server/repo/server_runner.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore.dart';

//! move handlers  of the auth service to a middle step between the authService and serverService
//! you can call this step serverAuth
//! and for the storage service you can add a step called serverStorage
class ServerService {
  final App app;
  final AuthServerSettings authServerSettings;

  ServerService(
    this.app, {
    required this.authServerSettings,
  }) {
    _pipeline = Pipeline();
    serverRunner = ServerRunner(app, _pipeline);
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

    return serverRunner.run();
  }

  ServerService addRouter(RouterInfo routerInfo) {
    bool jwtSecured = routerInfo.jwtSecured;
    bool emailMustBeVerified = routerInfo.emailMustBeVerified;
    bool appIdSecured = routerInfo.appIdSecured;
    Router router = routerInfo.router;

    //? run checks here
    if (!jwtSecured && emailMustBeVerified) {
      throw Exception(
          'emailMustBeVerified && !jwtSecured, to check if email must be verified user must be logged in first');
    }

    //? adding middlewares here
    // checking for app id for every
    if (appIdSecured) {
      router.addUpperMiddleware(
        null,
        HttpMethods.all,
        authServerSettings.authServerMiddlewares.checkAppId,
      );
    }
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
    // adding server check router
    Router router = Router()
      ..get(EndpointsConstants.serverAlive,
          (request, response, pathArgs) => response.write('server is live'));
    RouterInfo routerInfo = RouterInfo(router, appIdSecured: false);
    addRouter(routerInfo);

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
}
