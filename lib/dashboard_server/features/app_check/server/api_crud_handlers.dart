import 'dart:async';

import 'package:dart_verse_backend/constants/body_fields.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/datasources/api_key_info_datasource.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_hash_model.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_key_model.dart';
import 'package:dart_verse_backend/dashboard_server/features/app_check/data/models/api_user_model.dart';
import 'package:dart_verse_backend/errors/models/api_key_exceptions.dart';
import 'package:dart_verse_backend/errors/models/app_check_exceptions.dart';
import 'package:dart_verse_backend/errors/models/server_errors.dart';
import 'package:dart_verse_backend/errors/serverless_exception.dart';
import 'package:dart_verse_backend/layers/settings/server_settings/utils/send_response.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

class ApiCrudHandlers {
  final ApiKeyInfoDatasource _apiKeyInfoDatasource;

  const ApiCrudHandlers(this._apiKeyInfoDatasource);
  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future Function() method,
  ) async {
    try {
      return await method();
    } on ServerException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on AppCheckException catch (e) {
      return SendResponse.sendAuthErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ApiKeyException catch (e) {
      return SendResponse.sendAuthErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  FutureOr<PassedHttpEntity> listApiHashes(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      var res = await _apiKeyInfoDatasource.listApiKeys();
      var converted = res.map((e) => e.toJson()).toList();
      return SendResponse.sendDataToUser(response, converted);
    });
  }

  FutureOr<PassedHttpEntity> listApiKeys(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      var res = await _apiKeyInfoDatasource.listApiKeys();
      var converted = res.map(
        (e) {
          ApiUserModel apiUserModel = ApiUserModel.fromModels(
              e.toApiKey(_apiKeyInfoDatasource.encrypterSecretKey), e);
          return apiUserModel;
        },
      ).toList();
      return SendResponse.sendDataToUser(response, converted);
    });
  }

  FutureOr<PassedHttpEntity> generateSaveApiKey(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      String name;
      int? expirySeconds;
      Duration? expireAfter;
      try {
        Map<String, dynamic> body = await request.readAsJson();
        name = body[BodyFields.name];
        expirySeconds = body[BodyFields.expirySeconds];
        expireAfter =
            expirySeconds == null ? null : Duration(seconds: expirySeconds);
      } catch (e) {
        throw RequestBodyError();
      }
      ApiHashModel apiKey = await _apiKeyInfoDatasource.generateApiKey(
        name,
        expireAfter: expireAfter,
      );
      await _apiKeyInfoDatasource.saveHashModel(apiKey);
      ApiKeyModel apiKeyModel =
          apiKey.toApiKey(_apiKeyInfoDatasource.encrypterSecretKey);
      ApiUserModel apiUserModel = ApiUserModel.fromModels(apiKeyModel, apiKey);
      return SendResponse.sendDataToUser(
        response,
        apiUserModel.toJson(),
      );
    });
  }

  FutureOr<PassedHttpEntity> deleteApiKey(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      String apiHash;
      try {
        Map<String, dynamic> body = await request.readAsJson();
        apiHash = body[BodyFields.apiHash];
      } catch (e) {
        throw RequestBodyError();
      }

      await _apiKeyInfoDatasource.deleteApiKey(apiHash);
      return SendResponse.sendDataToUser(response, 'deleted');
    });
  }

  FutureOr<PassedHttpEntity> toggleApiActiveness(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      String apiHash;
      try {
        Map<String, dynamic> body = await request.readAsJson();
        apiHash = body[BodyFields.apiHash];
      } catch (e) {
        throw RequestBodyError();
      }

      var res = await _apiKeyInfoDatasource.toggleApiKeyActiveness(apiHash);
      ApiUserModel apiUserModel = ApiUserModel.fromModels(
          res.toApiKey(_apiKeyInfoDatasource.encrypterSecretKey), res);
      return SendResponse.sendDataToUser(response, apiUserModel.toJson());
    });
  }
}
