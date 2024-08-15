import 'package:dart_verse_backend_new/constants/reserved_keys.dart';

import '../../repositories/memory_ref/coll_ref_memory.dart';
import '../../repositories/memory_ref/doc_ref_memory.dart';

class MemoryDbDocument {
  final Map<String, List<Map<String, dynamic>>> _memoryDb;
  final CollRefMemory _collRef;
  final String _id;
  const MemoryDbDocument(this._memoryDb, this._collRef, this._id);
  //? here i will add the code for controlling a document from the memory db

  DocRefMemory set(
    Map<String, dynamic> newDoc,
  ) {
    String collId = _collRef.id;
    // create the doc parent collection if not exist
    if (_memoryDb[collId] == null) {
      _memoryDb[collId] = [];
    }
    // get the old data if not exist create one
    int index =
        _memoryDb[collId]!.indexWhere((element) => element[DBRKeys.id] == _id);

    // insert new one if the old one doesn't exist
    if (index == -1) {
      newDoc[DBRKeys.id] = newDoc[DBRKeys.id] ?? _id;
      return _collRef.insertDoc(newDoc);
    }
    // or just remove the old one and set the new one
    // the id of a doc can't be changed
    var oldDoc = _memoryDb[collId]![index];
    String docId = oldDoc[DBRKeys.id];
    newDoc[DBRKeys.id] = docId;
    // get the old doc index in the collection
    _memoryDb[collId]![index] = newDoc;
    var newDocRef = DocRefMemory(_id, _collRef, _memoryDb);
    return newDocRef;
  }

  DocRefMemory update(
    Map<String, dynamic> newDoc,
  ) {
    String collId = _collRef.id;
    if (_memoryDb[collId] == null) {
      _memoryDb[collId] = [];
    }
    int index =
        _memoryDb[collId]!.indexWhere((element) => element[DBRKeys.id] == _id);
    if (index == -1) {
      return _collRef.insertDoc(newDoc);
    }
    var updatedOldDoc = _memoryDb[collId]![index];
    // the id of a doc can't be changed
    newDoc[DBRKeys.id] = updatedOldDoc[DBRKeys.id];
    newDoc.forEach((key, value) {
      updatedOldDoc[key] = value;
    });
    return set(updatedOldDoc);
  }

  Map<String, dynamic>? getData() {
    String collId = _collRef.id;
    if (_memoryDb[collId] == null) return null;
    Map<String, dynamic>? doc = _memoryDb[collId]!.cast().firstWhere(
          (doc) => doc[DBRKeys.id] == _id,
          orElse: () => null,
        );
    return doc;
  }
}
