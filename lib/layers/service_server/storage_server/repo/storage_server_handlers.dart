import 'dart:async';

import 'package:dart_verse_backend_new/layers/services/storage_service/storage_service.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/impl/request_holder.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/impl/response_holder.dart';
import 'package:dart_webcore_new/dart_webcore_new/server/repo/passed_http_entity.dart';

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
