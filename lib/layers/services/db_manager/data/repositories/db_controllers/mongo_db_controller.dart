import 'package:mongo_dart/mongo_dart.dart';

import '../../../domain/repositories/db_controller.dart';
import '../mongo_ref/coll_ref_mongo.dart';

class MongoDbController implements DbController {
  final Db _db;
  const MongoDbController(this._db);

  CollRefMongo collection(String name) {
    CollRefMongo collRef = CollRefMongo(name, null, _db);
    return collRef;
  }
}
