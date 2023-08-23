import 'package:dart_verse/constants/reserved_keys.dart';
import 'package:uuid/uuid.dart';

import '../../../validation/doc_validation.dart';
import '../../repositories/memory_ref/coll_ref_memory.dart';
import '../../repositories/memory_ref/doc_ref_memory.dart';

//! i must define the memory controlling code in the memory db driver and just get a ref of that driver here to use it
//
class MemoryDbCollection {
  final Map<String, List<Map<String, dynamic>>> _memoryDb;
  final String _id;
  final String _name;
  final DocRefMemory? _docRefMemory;

  const MemoryDbCollection(
    this._memoryDb,
    this._id,
    this._name,
    this._docRefMemory,
  );

  CollRefMemory get _collRefMemory =>
      CollRefMemory(_name, _docRefMemory, _memoryDb);
  //? here i will add the code for controlling a collection from the memory db
  DocRefMemory insertDoc(
    Map<String, dynamic> doc,
  ) {
    String collId = _id;
    // first check if the collection exist
    // here i need to check if the collection has a parent doc or not
    //
    if (_memoryDb[collId] == null) {
      _memoryDb[collId] = [];
    }

    // create the doc id
    String docId = doc[DBRKeys.id] ?? Uuid().v4();
    // validating the doc
    DocValidation docValidation = DocValidation(docId, doc);
    doc = docValidation.validate();
    // here just save the new doc
    _memoryDb[collId]!.add(doc);
    return DocRefMemory(
      docId,
      _collRefMemory,
      _memoryDb,
    );
  }

  DocRefMemory? getDocRefById(
    String docId,
  ) {
    String collId = _id;
    if (_memoryDb[collId] == null) return null;
    Map<String, dynamic>? doc = _memoryDb[collId]!.cast().firstWhere(
          (doc) => doc[DBRKeys.id] == docId,
          orElse: () => null,
        );
    if (doc == null) {
      return null;
    } else {
      String docId = doc[DBRKeys.id];
      return DocRefMemory(docId, _collRefMemory, _memoryDb);
    }
  }

  DocRefMemory? getDocWhere(
    bool Function(dynamic element) testMethod,
  ) {
    String collId = _id;
    if (_memoryDb[collId] == null) return null;
    Map<String, dynamic>? doc = _memoryDb[collId]!.cast().firstWhere(
          testMethod,
          orElse: () => null,
        );
    if (doc == null) {
      return null;
    } else {
      String docId = doc[DBRKeys.id];
      return DocRefMemory(docId, _collRefMemory, _memoryDb);
    }
  }

  Iterable<DocRefMemory> getAllDocuments() {
    String collId = _id;
    // check if coll exists or not
    if (_memoryDb[collId] == null) {
      return [];
    }
    // gets actual docs
    var docs = _memoryDb[collId]!.map((e) {
      var docRef = DocRefMemory(e[DBRKeys.id], _collRefMemory, _memoryDb);
      return docRef;
    });
    return docs;
  }
}
