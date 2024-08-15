import 'package:dart_verse_backend_new/layers/services/db_manager/db_providers/impl/memory_db/memory_db_provider.dart';
import 'package:dart_verse_backend_new/layers/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';

class DBSettings {
  // final ConnLink _connLink;
  final MemoryDBProvider? _memoryDBProvider;
  final MongoDBProvider? _mongoDBProvider;

  const DBSettings({
    MemoryDBProvider? memoryDBProvider,
    MongoDBProvider? mongoDBProvider,
  })  : _mongoDBProvider = mongoDBProvider,
        _memoryDBProvider = memoryDBProvider;

  MemoryDBProvider? get memoryDBProvider => _memoryDBProvider;
  MongoDBProvider? get mongoDBProvider => _mongoDBProvider;
}
