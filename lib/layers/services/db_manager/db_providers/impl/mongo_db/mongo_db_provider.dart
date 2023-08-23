import 'package:dart_verse/errors/models/database_errors.dart';
import 'package:dart_verse/layers/settings/db_settings/repo/conn_link.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../repo/db_provider.dart';

class MongoDBProvider implements DBProvider {
  final MongoDbConnLink _connLink;
  MongoDBProvider(this._connLink);
  MongoDbConnLink get connLink => _connLink;
  Db? _db;
  Db get db {
    if (_db == null) {
      throw MongoDbNotInitializedYet();
    }
    return _db!;
  }

  void setDb(Db db) {
    _db = db;
  }
}
