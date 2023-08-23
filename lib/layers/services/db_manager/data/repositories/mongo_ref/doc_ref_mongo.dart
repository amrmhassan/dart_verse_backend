import 'package:dart_verse_backend/layers/services/db_manager/data/datasource/mongo_db/mongo_db_document.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../domain/repositories/db_entity.dart';
import '../../../domain/repositories/doc_ref_repo.dart';
import '../../../utils/doc_ref_utils.dart';
import 'coll_ref_mongo.dart';
import '../path_entity.dart';

class DocRefMongo extends MongoDbDocument implements DbEntity, DocRefRepo {
  @override
  final String id;
  @override
  final CollRefMongo parentColl;
  final Db _db;

  DocRefMongo(this.id, this.parentColl, this._db) : super(id, parentColl);

  @override
  PathEntity get path => DocRefUtils.getDocPath(id, this, parentColl);

  @override
  CollRefMongo collection(String name) {
    return CollRefMongo(name, this, _db);
  }
}
