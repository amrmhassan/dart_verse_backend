import 'package:dart_verse_backend_new/constants/logger.dart';

class MemoryDbConnect {
  final Map<String, List<Map<String, dynamic>>>? memoryDb;
  const MemoryDbConnect(this.memoryDb);

  Future<Map<String, List<Map<String, dynamic>>>?> connect() async {
    if (memoryDb == null) {
      logger.i('no memory db provided, skipping');
      return null;
    }
    logger.i('connected to memory db');
    return memoryDb;
  }
}
