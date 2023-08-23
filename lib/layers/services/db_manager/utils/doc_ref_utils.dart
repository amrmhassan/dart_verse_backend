import '../data/repositories/path_entity.dart';
import '../domain/repositories/coll_ref_repo.dart';
import '../domain/repositories/db_entity.dart';

class DocRefUtils {
  static PathEntity getDocPath(
      String id, DbEntity entity, CollRefRepo parentColl) {
    return PathEntity(
      name: id,
      entity: entity,
      parentPath: parentColl.path,
    );
  }
}
