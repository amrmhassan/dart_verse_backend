import 'package:dart_verse/layers/services/db_manager/data/repositories/mongo_ref/coll_ref_mongo.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDbDocument {
  final String _id;
  final CollRefMongo _collRef;
  const MongoDbDocument(
    this._id,
    this._collRef,
  );

  /// this will update certain values presented in the doc object
  Future<WriteResult> update(
    Map<String, dynamic> doc, {
    bool upsert = true,
  }) async {
    var selector = where.eq('_id', _id);
    var updateQuery = modify;
    doc.forEach((key, value) {
      updateQuery = updateQuery.set(key, value);
    });
    return _collRef.updateOne(selector, updateQuery, upsert: upsert);
  }

  /// this will delete the document
  Future<WriteResult> delete() async {
    var selector = where.eq('_id', _id);
    return _collRef.deleteOne(selector);
  }

  /// this will remove the old document and add another one with the same id
  Future<WriteResult> set(
    Map<String, dynamic> doc, {
    bool upset = true,
  }) async {
    var deleteRes = await delete();
    if ((deleteRes.failure || deleteRes.isFailure) && !upset) {
      return deleteRes;
    }
    doc['_id'] = _id;
    return _collRef.insertOne(doc);
  }

  Future<Map<String, dynamic>?> getData() async {
    var selector = where.eq('_id', _id);
    return _collRef.findOne(selector);
  }
}
