import 'package:dart_verse_backend/constants/logger.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../../layers/settings/db_settings/repo/conn_link.dart';

class MongoDbConnect {
  final String _appName;
  final MongoDbConnLink? _connLink;
  const MongoDbConnect(this._connLink, this._appName);

  Future<Db?> connect() async {
    String? uri = _connLink?.getConnLink;
    if (uri == null) {
      logger.i('no mongoDb Provider, skipping mongoDB connect');
      return null;
    }

    late Db db;

    logger.i('trying to connect to mongo db for app $_appName...');

    if (_connLink is MongoDbDNSConnLink) {
      db = await _dnsConnect(uri);
    } else {
      db = await _normalConnect(uri);
    }

    logger.i('connected to mongo db.');

    return db;
  }

  Future<Db> _dnsConnect(String uri) async {
    Db db = await Db.create(uri);
    await db.open();
    return db;
  }

  Future<Db> _normalConnect(String uri) async {
    Db db = Db(uri);
    await db.open();
    return db;
  }
}
