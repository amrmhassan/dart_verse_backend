import '../../data/repositories/path_entity.dart';
import 'coll_ref_repo.dart';

abstract class DocRefRepo {
  final String id;
  final CollRefRepo parentColl;
  PathEntity get path;

  const DocRefRepo(this.id, this.parentColl);

  CollRefRepo collection(String name);
}
