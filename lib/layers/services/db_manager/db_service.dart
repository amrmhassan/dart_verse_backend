import 'package:dart_verse_backend_new/constants/logger.dart';
import 'package:dart_verse_backend_new/errors/models/app_exceptions.dart';
import 'package:dart_verse_backend_new/errors/models/database_errors.dart';
import 'package:dart_verse_backend_new/features/app_database/controllers/db_connect.dart';
import 'package:dart_verse_backend_new/layers/services/service.dart';
import 'package:dart_verse_backend_new/layers/settings/app/app.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'data/repositories/db_controllers/memory_db_controller.dart';
import 'data/repositories/db_controllers/mongo_db_controller.dart';

class DbService implements DVService {
  final App _app;
  DbService(App app) : _app = app;
  bool _dbConnected = false;
  Db? db;

  bool get connected {
    try {
      return db != null && db!.masterConnection.connected;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<void> reconnect() async {
    await connectToDb(force: true);
  }

  /// MongoDb controller
  MongoDbController get mongoDbController {
    if (!_dbConnected) {
      throw DbNotConnectedException();
    }
    if (_app.dbSettings.mongoDBProvider == null) {
      throw NoMongoDbProviderExceptions();
    }
    if (_mongoDbController == null) {
      throw NoMongoDbProviderExceptions();
    }
    return _mongoDbController!;
  }

  /// `Non persistent` db, data saved to RAM
  MemoryDbController get memoryDbController {
    if (!_dbConnected) {
      throw DbNotConnectedException();
    }
    if (_app.dbSettings.memoryDBProvider == null) {
      throw NoMemoryDbProviderExceptions();
    }

    if (_memoryDbController == null) {
      throw NoMemoryDbProviderExceptions();
    }

    return _memoryDbController!;
  }

  //#  Connect DBs
  Future<Db?> connectToDb({
    bool force = false,
  }) async {
    if (_dbConnected && !force) {
      throw DbAlreadyConnectedException();
    }
    DbConnect dbConnect = DbConnect(_app);
    db = await dbConnect.connectAllProvidedDBs(
      setMemoryController: _setMemoryController,
      setMongoDb: _setMongoDb,
    );
    _dbConnected = true;
    return db;
  }

  //# setting DBs after connecting
  void _setMongoDb(Db db) {
    _app.dbSettings.mongoDBProvider!.setDb(db);
    _setMongoController(MongoDbController(db));
  }

  //# getting Dbs references
  /// get the actual mongoDb reference for more control on the mongo db
  Db get getMongoDB {
    if (_app.dbSettings.mongoDBProvider == null) {
      throw NoMongoDbProviderExceptions();
    }
    return _app.dbSettings.mongoDBProvider!.db;
  }

  /// get the actual memory db Object(data stored on this object)
  Map<String, List<Map<String, dynamic>>> get getMemoryDb {
    if (_app.dbSettings.memoryDBProvider == null) {
      throw NoMemoryDbProviderExceptions();
    }
    return _app.dbSettings.memoryDBProvider!.memoryDb;
  }

  //# getting db controllers
  MongoDbController? _mongoDbController;

  MemoryDbController? _memoryDbController;

  //# settings db controllers
  void _setMongoController(MongoDbController controller) {
    _mongoDbController = controller;
  }

  /// you don't need to play with method
  void _setMemoryController(MemoryDbController controller) {
    _memoryDbController = controller;
  }

  App get app => _app;
}
