import 'package:mongo_dart/mongo_dart.dart';

import '../../../../layers/settings/db_settings/repo/conn_link.dart';

class MongoDbConnect {
  final MongoDbConnLink? _connLink;
  const MongoDbConnect(this._connLink);

  Future<Db?> connect() async {
    String? uri = _connLink?.getConnLink;
    if (uri == null) {
      print('no mongoDb Provider, skipping mongoDB connect');
      return null;
    }

    late Db db;

    print('trying to connect to mongo db...');

    if (_connLink is MongoDbDNSConnLink) {
      db = await _dnsConnect(uri);
    } else {
      db = await _normalConnect(uri);
    }

    print('connected to mongo db.');

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
