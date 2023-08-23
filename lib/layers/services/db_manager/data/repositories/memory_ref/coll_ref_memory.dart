import 'package:mongo_dart/mongo_dart.dart';

import '../../../domain/repositories/coll_ref_repo.dart';
import '../../../domain/repositories/db_entity.dart';
import '../../../utils/coll_ref_utils.dart';
import '../../datasource/memory_db/memory_db_collection.dart';
import 'doc_ref_memory.dart';
import '../path_entity.dart';

class CollRefMemory extends MemoryDbCollection
    implements CollRefRepo, DbEntity {
  @override
  final String name;
  @override
  final DocRefMemory? parentDoc;
  final Map<String, List<Map<String, dynamic>>> _memoryDb;

  CollRefMemory(this.name, this.parentDoc, this._memoryDb)
      : super(_memoryDb, CollRefUtils.getCollId(name, parentDoc), name,
            parentDoc);

  @override
  DocRefMemory doc([String? id]) {
    //! apply doc id restriction
    String docId = id ?? ObjectId().toHexString();
    return DocRefMemory(docId, this, _memoryDb);
  }

  @override
  String get id => CollRefUtils.getCollId(name, parentDoc);

  @override
  PathEntity get path => CollRefUtils.getCollPath(this, name, parentDoc);
}
