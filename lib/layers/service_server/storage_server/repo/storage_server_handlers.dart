import 'dart:async';

import 'package:dart_verse_backend/layers/services/storage_service/storage_service.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

abstract class StorageServerHandlers {
  late StorageService storageService;

  FutureOr<PassedHttpEntity> upload(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );

  FutureOr<PassedHttpEntity> download(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );

  FutureOr<PassedHttpEntity> delete(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
  FutureOr<PassedHttpEntity> listChildren(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
}
