import 'dart:async';
import 'dart:isolate';

Future<T> customCompute<T, E>(
  FutureOr<T> Function(E message) callback,
  E message,
) async {
  ReceivePort receivePort = ReceivePort();
  Isolate isolate = await Isolate.spawn((message) {}, message);
  var res = await _wrapper(callback, message, receivePort.sendPort);
  isolate.kill();
  receivePort.close();
  return res;
}

Future<T> _wrapper<T, E>(
  FutureOr<T> Function(E message) callback,
  E message,
  SendPort sendPort,
) async {
  var res = await callback(message);
  return res;
}
