import '../../data/repositories/path_entity.dart';
import 'doc_ref_repo.dart';

abstract class CollRefRepo {
  final String name;
  String get id;
  final DocRefRepo? parentDoc;
  PathEntity get path;

  const CollRefRepo(this.name, this.parentDoc);

  DocRefRepo doc([String? id]);
}
