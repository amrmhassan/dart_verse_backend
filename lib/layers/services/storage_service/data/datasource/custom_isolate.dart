import 'dart:async';
import 'dart:isolate';

class CustomIsolate {
  static Future<T> compute<T, E>(
    FutureOr<T> Function(E message) callback,
    E message,
  ) async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn((message) {}, message);
    await _wrapper(callback, message, receivePort.sendPort);
    var res = await receivePort.first;
    isolate.kill();
    receivePort.close();
    return res;
  }

  static Future<T> _wrapper<T, E>(
    FutureOr<T> Function(E message) callback,
    E message,
    SendPort sendPort,
  ) async {
    var res = await callback(message);
    sendPort.send(res);
    return res;
  }
}
