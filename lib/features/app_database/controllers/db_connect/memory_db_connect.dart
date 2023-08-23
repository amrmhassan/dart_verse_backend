class MemoryDbConnect {
  final Map<String, List<Map<String, dynamic>>>? memoryDb;
  const MemoryDbConnect(this.memoryDb);

  Future<Map<String, List<Map<String, dynamic>>>?> connect() async {
    if (memoryDb == null) {
      print('no memory db provided, skipping');
      return null;
    }
    print('connected to memory db');
    return memoryDb;
  }
}
