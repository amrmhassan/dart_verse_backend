import 'dart:isolate';
import 'package:dart_verse_backend_new/utils/string_utils.dart';
import 'package:path/path.dart' as path_operations;
import 'dart:io';

class StorageOperations {
  static Future<File> copyFile(String source, String destination) async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _copyFileIsolate,
      _CopyFileArguments(source, destination, receivePort.sendPort, false),
    );
    await receivePort.first;
    isolate.kill();
    var destFile = File(destination);
    if (!destFile.existsSync()) {
      throw Exception('file wasn\'t copied');
    }
    return destFile;
  }

  static Future<File> moveFile(String source, String destination) async {
    ReceivePort receivePort = ReceivePort();
    Isolate isolate = await Isolate.spawn(
      _copyFileIsolate,
      _CopyFileArguments(source, destination, receivePort.sendPort, true),
    );
    await receivePort.first;
    isolate.kill();
    var destFile = File(destination);
    if (!destFile.existsSync()) {
      throw Exception('file wasn\'t moved');
    }
    return destFile;
  }

  static Future<File> rename(
    String filePath,
    String newName, {
    bool keepExtension = true,
  }) async {
    File sourceFile = File(filePath);
    String fileExtension = path_operations.extension(filePath);

    String parentPath = sourceFile.parent.path.strip('/');

    String newPath;
    if (keepExtension) {
      newPath = '$parentPath/$newName$fileExtension';
    } else {
      newPath = '$parentPath/$newName';
    }
    return sourceFile.rename(newPath);
  }
}

void _copyFileIsolate(_CopyFileArguments args) {
  String source = args.source;
  String destination = args.destination;
  SendPort sendPort = args.sendPort;

  String fileName = path_operations.basename(source);
  String destFilePath = '${destination.strip('/')}/$fileName';
  File destFile = File(destFilePath);

  if (destFile.existsSync()) {
    sendPort.send(Exception('file already exists with the same name'));
    return;
  }

  destFile.createSync(recursive: true);
  var destRaf = destFile.openSync(mode: FileMode.write);
  File sourceFile = File(source);
  var sub = sourceFile.openRead().listen((event) {
    destRaf.writeFromSync(event);
  });
  sub.onDone(() {
    destRaf.closeSync();
    sub.cancel();
    sendPort.send(null);
    if (args.deleteSourceAfter) {
      // delete the original file here
      sourceFile.deleteSync();
    }
  });
}

class _CopyFileArguments {
  final String source;
  final String destination;
  final SendPort sendPort;
  final bool deleteSourceAfter;

  _CopyFileArguments(
    this.source,
    this.destination,
    this.sendPort, [
    this.deleteSourceAfter = false,
  ]);
}
