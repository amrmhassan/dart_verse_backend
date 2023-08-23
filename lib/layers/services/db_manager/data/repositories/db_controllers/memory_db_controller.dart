import '../../../domain/repositories/db_controller.dart';
import '../memory_ref/coll_ref_memory.dart';

class MemoryDbController implements DbController {
  final Map<String, List<Map<String, dynamic>>> _memoryBb;
  const MemoryDbController(this._memoryBb);

  CollRefMemory collection(String name) {
    CollRefMemory collRef = CollRefMemory(name, null, _memoryBb);
    return collRef;
  }
}
