import '../data/repositories/path_entity.dart';
import '../domain/repositories/db_entity.dart';
import '../domain/repositories/doc_ref_repo.dart';

class CollRefUtils {
  static String getCollId(String name, DocRefRepo? parentDoc) {
    if (parentDoc == null) {
      return name;
    } else {
      return '$name|${parentDoc.id}|${parentDoc.parentColl.name}';
    }
  }

  static PathEntity getCollPath(
      DbEntity entity, String name, DocRefRepo? parentDoc) {
    if (parentDoc == null) {
      return PathEntity(
        name: name,
        entity: entity,
        parentPath: null,
      );
    } else {
      return PathEntity(
        name: name,
        entity: entity,
        parentPath: parentDoc.path,
      );
    }
  }
}
