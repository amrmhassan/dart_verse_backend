import 'dart:async';
import 'dart:io';

import 'package:dart_verse/constants/endpoints_constants.dart';
import 'package:dart_verse/errors/models/auth_server_exceptions.dart';
import 'package:dart_verse/layers/service_server/auth_server/auth_server.dart';
import 'package:dart_verse/layers/service_server/db_server/db_server.dart';
import 'package:dart_verse/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore.dart';

//! move handlers  of the auth service to a middle step between the authService and serverService
//! you can call this step serverAuth
//! and for the storage service you can add a step called serverStorage
class ServerService {
  final App _app;
  final AuthServer? _authServer;
  final DBServer? _dbServer;

  ServerService(
    this._app, {
    AuthServer? authServer,
    DBServer? dbServer,
  })  : _authServer = authServer,
        _dbServer = dbServer {
    _cascade = Cascade();
  }

  late Cascade _cascade;

  Future<HttpServer> runServer({
    bool log = false,
  }) async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
    _addServicesEndpoints();
    ServerHolder serverHolder = ServerHolder(_cascade);
    serverHolder.addGlobalMiddleware(logRequest);
    var server = await serverHolder.bind(ip, port);
    return server;
  }

  //! data in this like idFieldName and role and their values will be checked from the jwt payload
  //! try to combine the addRouter and addPipeline
  //! i want to create use it like this
  /*
              the addRouter method should be provided with the place of the provided user id
              whether it should be in body or as authorization in headers bearer
              and the user id key name where it will be '_id' or 'id' or whatever
              addRouter(put parameters here).secure(bool userAuth = true, bool userData = false,(map allUserDataWillBeHere(Auth And User Data)){
                if userAuth is true the map allUserDataWillBeHere will contain userAuth, and the same for userData
                return bool;
              })

              and the add Router method should return a secure object or SecureHandler Object
              this secure handler class i don't know yet what to add in it but 
              */
  ServerService addRouter(
    Router router, {
    bool jwtSecured = false,
    bool emailMustBeVerified = false,
    bool appIdSecured = true,
  }) {
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
        authServer.authServerSettings.authServerMiddlewares.checkAppId,
      );
    }
    // checking if jwt is added and user logged in
    if (jwtSecured) {
      router
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServer
                .authServerSettings.authServerMiddlewares.checkJwtInHeaders,
            signature: 'checkJwtInHeadersFromUserCustomRoutes',
          )
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServer
                .authServerSettings.authServerMiddlewares.checkJwtForUserId,
            signature: 'checkJwtForUserId',
          );
    }
    // checking if email is verified
    if (emailMustBeVerified) {
      router.addUpperMiddleware(
        null,
        HttpMethods.all,
        authServer
            .authServerSettings.authServerMiddlewares.checkUserEmailVerified,
      );
    }
    Pipeline pipeline = Pipeline().addRouter(router);

    //?

    _cascade = _cascade.add(pipeline);
    return this;
  }

  Cascade get cascade {
    return _cascade;
  }

  AuthServer get authServer {
    if (_authServer == null) {
      throw NoAuthServerSettings();
    }
    return _authServer!;
  }

  DBServer get dbServer {
    if (_dbServer == null) {
      throw NoAuthServerSettings();
    }
    return _dbServer!;
  }

  void _addServicesEndpoints() {
    // adding server check router
    addRouter(Router()
      ..get(EndpointsConstants.serverAlive,
          (request, response, pathArgs) => response.write('server is live')));

    // adding routers for auth service
    if (_authServer != null) {
      addRouter(_authServer!.getRouter());
    }

    // adding routers for db service
    if (_dbServer != null) {
      addRouter(_dbServer!.getRouter());
    }
  }
}
