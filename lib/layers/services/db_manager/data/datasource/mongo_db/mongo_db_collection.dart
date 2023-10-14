import 'dart:async';

import 'package:mongo_dart/mongo_dart.dart';

//! to add the watch for changes you should override the method responsible for updating or inserting in mongodb
//! then calling (await super.thatMethod) then adding the change to the stream controller sink
//! make the stream controller to be broadcast

//! and the custom watch method will refer to that stream

class MongoDbCollection extends DbCollection {
  MongoDbCollection(super.db, super.collectionName);

  /// this just convert the normal stream find method into a future return
  Future<List<Map<String, dynamic>>> futureFind([selector]) async {
    Completer<List<Map<String, dynamic>>> completer =
        Completer<List<Map<String, dynamic>>>();

    List<Map<String, dynamic>> data = [];

    var stream = find(selector).listen((event) {
      data.add(event);
    });
    stream.onDone(() {
      completer.complete(data);
    });
    return completer.future;
  }

  Future<List<Map<String, dynamic>>> getAllDocuments() async {
    return futureFind();
  }

  /// this method depends on the _id property, so if you inserted a custom _id it will sort by your custom _id and this will cause a mis-sorting
  Future<Map<String, dynamic>> lastDocument() async {
    var selector = where.limit(1).sortBy('_id', descending: true);
    var res = await futureFind(selector);
    return res.first;
  }

  /// this method depends on the _id property, so if you inserted a custom _id it will sort by your custom _id and this will cause a mis-sorting
  Future<Map<String, dynamic>> firstDocument() async {
    var selector = where.limit(1).sortBy('_id');
    var res = await futureFind(selector);
    return res.first;
  }

  //# watching insertion
//   final StreamController<Map<String, dynamic>> _watchSC =
//       StreamController<Map<String, dynamic>>.broadcast();

//   Stream<Map<String, dynamic>> customWatch(
//     bool Function(Map<String, dynamic> doc) test,
//   ) =>
//       _watchSC.stream.where(test);

// //? 1] the insertion watch
//   @override
//   Future<Map<String, dynamic>> legacyInsertAll(
//       List<Map<String, dynamic>> documents,
//       {WriteConcern? writeConcern}) async {
//     var res =
//         await super.legacyInsertAll(documents, writeConcern: writeConcern);
//     for (var doc in documents) {
//       _watchSC.add(doc);
//     }
//     return res;
//   }

//   //? 1] insert one
//   @override
//   Future<WriteResult> insertOne(Map<String, dynamic> document,
//       {WriteConcern? writeConcern, bool? bypassDocumentValidation}) async {
//     var res = await super.insertOne(
//       document,
//       bypassDocumentValidation: bypassDocumentValidation,
//       writeConcern: writeConcern,
//     );
//     _watchSC.add(document);
//     return res;
//   }

//   @override
//   Future<Map<String, dynamic>> insert(Map<String, dynamic> document,
//       {WriteConcern? writeConcern}) async {
//     var res = await super.insert(document, writeConcern: writeConcern);
//     _watchSC.add(document);
//     return res;
//   }
}
