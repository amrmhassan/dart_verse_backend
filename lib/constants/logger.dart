// ignore_for_file: avoid_print

import 'package:logger/logger.dart';

VerseLogger logger = VerseLogger();

class VerseLogger extends Logger {
  @override
  void log(Level level, message, [error, StackTrace? stackTrace]) {
    print(message);
  }
}
