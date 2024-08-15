import 'package:dart_verse_backend_new/layers/services/db_manager/db_providers/repo/db_provider.dart';

class MemoryDBProvider implements DBProvider {
  final Map<String, List<Map<String, dynamic>>> memoryDb;
  const MemoryDBProvider(this.memoryDb);
}
