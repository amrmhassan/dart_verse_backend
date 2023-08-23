abstract class ServerLessException implements Exception {
  late String message;
  final String code;
  final int errorCode;
  ServerLessException(
    this.code, {
    this.errorCode = 500,
  });

  @override
  String toString() {
    return '$runtimeType: $message \ncode: $code';
  }
}
