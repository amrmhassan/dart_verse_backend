//? max collection name is 255 letters so i have 250 letters to play with so 250/3 is 80 letters
//? doc ids and coll naming restrictions
//# 1] no spaces
//# 2] max size is 80 bytes
//# 3] can't contains   /\. "$*<>:|?   characters

// this class might be used to reconstruct the ref object from the path of the entity(doc or collection)
import '../../domain/repositories/db_entity.dart';

class PathEntity {
  /// this will be the name of the collection or id of the document
  final String name;
  final DbEntity entity;
  final PathEntity? parentPath;

  const PathEntity({
    required this.name,
    required this.entity,
    required this.parentPath,
  });

  String get _path {
    if (parentPath == null) {
      return name;
    } else {
      return '${parentPath!._path}/$name';
    }
  }

  @override
  String toString() {
    return _path;
  }
}
