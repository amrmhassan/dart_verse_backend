import 'package:dart_verse_backend/constants/path_fields.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:dart_verse_backend/layers/service_server/service_server.dart';
import 'package:dart_verse_backend/layers/services/web_server/models/router_info.dart';
import 'package:dart_verse_backend/layers/service_server/auth_server/repo/auth_server_settings.dart';
import 'package:dart_webcore/dart_webcore.dart';

class AuthServer implements ServiceServerLayer {
  final AuthServerSettings _authServerSettings;

  @override
  App app;
  AuthServer(this.app, this._authServerSettings);

  AuthServerSettings get authServerSettings {
    return _authServerSettings;
  }

  @override
  List<RouterInfo> addRouters() {
    String login = app.endpoints.authEndpoints.login;
    String register = app.endpoints.authEndpoints.register;
    String getVerificationEmail =
        app.endpoints.authEndpoints.getVerificationEmail;
    String verifyEmail = app.endpoints.authEndpoints.verifyEmail;
    String changePassword = app.endpoints.authEndpoints.changePassword;
    String forgetPassword = app.endpoints.authEndpoints.forgetPassword;
    String logoutFromAllDevices =
        app.endpoints.authEndpoints.logoutFromAllDevices;
    String logout = app.endpoints.authEndpoints.logout;
    String updateUserData = app.endpoints.authEndpoints.updateUserData;
    String deleteUserData = app.endpoints.authEndpoints.deleteUserData;
    String fullyDeleteUser = app.endpoints.authEndpoints.fullyDeleteUser;

    // String forgetPassword = _app.endpoints.authEndpoints.forgetPassword;

    // other needed data
    int port = app.serverSettings.mainServerSettings.port;
    String host = app.backendHost;

    // adding auth endpoints pipeline
    var authRouter = Router()
      //? won't check for app id here (can be used from a browser)
      ..get(
        '$verifyEmail/<${PathFields.jwt}>',
        _authServerSettings.authServerHandlers.verifyEmail,
      )
      //? will check for app id from here
      ..addRouterMiddleware(
        _authServerSettings.authServerMiddlewares.checkAppId,
      )
      ..post(
        login,
        _authServerSettings.authServerHandlers.login,
      )
      ..post(
        register,
        _authServerSettings.authServerHandlers.register,
      )
      ..post(
        forgetPassword,
        _authServerSettings.authServerHandlers.forgetPassword,
      )
      //? will check for jwt from here
      ..addRouterMiddleware(
        _authServerSettings.authServerMiddlewares.checkJwtInHeaders,
        signature: 'checkJwtInHeadersFromAuthEndpoints',
      )
      ..addRouterMiddleware(
        _authServerSettings.authServerMiddlewares.checkJwtForUserId,
        signature: 'checkJwtForUserId',
      )
      ..post(
        getVerificationEmail,
        (request, response, pathArgs) =>
            _authServerSettings.authServerHandlers.getVerificationEmail(
          request,
          response,
          pathArgs,
          // i need the host here and the port
          '$host:$port$verifyEmail/',
        ),
      )
      ..post(
        changePassword,
        _authServerSettings.authServerHandlers.changePassword,
      )
      ..post(
        logoutFromAllDevices,
        _authServerSettings.authServerHandlers.logoutFromAllDevices,
      )
      ..post(
        logout,
        _authServerSettings.authServerHandlers.logout,
      )
      ..post(
        updateUserData,
        _authServerSettings.authServerHandlers.updateUserData,
      )
      ..post(
        deleteUserData,
        _authServerSettings.authServerHandlers.deleteUserData,
      )
      ..post(
        fullyDeleteUser,
        _authServerSettings.authServerHandlers.fullyDeleteUser,
      );
    RouterInfo authRouterInfo = RouterInfo(authRouter);
    return [authRouterInfo];
  }
}
