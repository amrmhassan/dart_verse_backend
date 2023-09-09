import 'package:dart_verse_backend/constants/endpoints_constants.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_info_datasource.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/server/api_crud_handlers.dart';
import 'package:dart_verse_backend/layers/services/web_server/models/router_info.dart';
import 'package:dart_webcore/dart_webcore.dart';

class ApiCRUDServer {
  final ApiKeyInfoDatasource _apiKeyInfoDatasource;
  late ApiCrudHandlers _handlers;
  ApiCRUDServer(this._apiKeyInfoDatasource) {
    _handlers = ApiCrudHandlers(_apiKeyInfoDatasource);
  }

  RouterInfo getRouter() {
    Router router = Router()
      ..get(
        EndpointsConstants.listApiKeys,
        _handlers.listApiKeys,
      )
      ..post(
        EndpointsConstants.generateApiKey,
        _handlers.generateSaveApiKey,
      )
      ..delete(
        EndpointsConstants.deleteApiKey,
        _handlers.deleteApiKey,
      )
      ..post(
        EndpointsConstants.toggleApiKeyActiveness,
        _handlers.toggleApiActiveness,
      );
    RouterInfo routerInfo = RouterInfo(
      router,
      jwtSecured: true,
    );
    return routerInfo;
  }
}
