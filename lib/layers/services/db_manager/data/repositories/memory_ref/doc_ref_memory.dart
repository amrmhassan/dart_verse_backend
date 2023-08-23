import '../../../domain/repositories/coll_ref_repo.dart';
import '../../../domain/repositories/db_entity.dart';
import '../../../domain/repositories/doc_ref_repo.dart';
import '../../../utils/doc_ref_utils.dart';
import '../../datasource/memory_db/memory_db_document.dart';
import 'coll_ref_memory.dart';
import '../path_entity.dart';

class DocRefMemory extends MemoryDbDocument implements DocRefRepo, DbEntity {
  @override
  final String id;
  @override
  final CollRefMemory parentColl;
  final Map<String, List<Map<String, dynamic>>> _memoryDb;

  const DocRefMemory(this.id, this.parentColl, this._memoryDb)
      : super(_memoryDb, parentColl, id);

  @override
  CollRefRepo collection(String name) {
    return CollRefMemory(name, this, _memoryDb);
  }

  @override
  PathEntity get path => DocRefUtils.getDocPath(id, this, parentColl);
}
