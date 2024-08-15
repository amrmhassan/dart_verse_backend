import 'package:dart_verse_backend_new/layers/services/db_manager/data/repositories/path_entity.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../domain/repositories/coll_ref_repo.dart';
import '../../../domain/repositories/db_entity.dart';
import '../../../utils/coll_ref_utils.dart';
import '../../datasource/mongo_db/mongo_db_collection.dart';
import 'doc_ref_mongo.dart';

class CollRefMongo extends MongoDbCollection implements DbEntity, CollRefRepo {
  @override
  final String name;
  @override
  final DocRefMongo? parentDoc;
  final Db _db;

  CollRefMongo(this.name, this.parentDoc, this._db)
      : super(_db, CollRefUtils.getCollId(name, parentDoc));

  @override
  String get id => CollRefUtils.getCollId(name, parentDoc);

  @override
  PathEntity get path => CollRefUtils.getCollPath(this, name, parentDoc);

  @override
  DocRefMongo doc([String? id]) {
    //! apply doc id restriction
    String docId = id ?? ObjectId().toHexString();
    return DocRefMongo(docId, this, _db);
  }
}
