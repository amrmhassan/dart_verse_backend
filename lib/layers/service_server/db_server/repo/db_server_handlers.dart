import 'dart:async';

import 'package:dart_verse_backend_new/layers/services/db_manager/db_service.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

abstract class DbServerHandlers {
  late App app;
  late DbService dbService;

  FutureOr<PassedHttpEntity> getConnLink(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
}
