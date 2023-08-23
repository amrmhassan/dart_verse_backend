import 'package:dart_verse/features/app_database/controllers/db_connect/memory_db_connect.dart';
import 'package:dart_verse/features/app_database/controllers/db_connect/mongo_db_connect.dart';
import 'package:dart_verse/layers/services/db_manager/data/repositories/db_controllers/memory_db_controller.dart';
import 'package:dart_verse/layers/settings/app/app.dart';
import 'package:dart_verse/layers/settings/db_settings/repo/conn_link.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DbConnect {
  final App _app;

  const DbConnect(this._app);
  Future<void> connectAllProvidedDBs({
    required Function(MemoryDbController) setMemoryController,
    required Function(Db) setMongoDb,
  }) async {
    //? trying to connect to mongodb if exist
    if (_app.dbSettings.mongoDBProvider != null) {
      MongoDbConnLink mongoDbConnLink =
          _app.dbSettings.mongoDBProvider!.connLink;
      MongoDbConnect mongoDbConnect = MongoDbConnect(mongoDbConnLink);
      Db? db = await mongoDbConnect.connect();
      // setting the app _db because the app depends on it
      if (db != null) {
        setMongoDb(db);
      }
    }

    //? trying to connect to memory db if exist
    if (_app.dbSettings.memoryDBProvider != null) {
      var memoryDb = _app.dbSettings.memoryDBProvider!.memoryDb;
      MemoryDbConnect memoryDbConnect = MemoryDbConnect(memoryDb);
      await memoryDbConnect.connect();
      setMemoryController(MemoryDbController(memoryDb));
    }
  }
}
