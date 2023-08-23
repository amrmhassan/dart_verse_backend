import 'dart:io';

import 'package:hive/hive.dart';

import '../constants/global_constants.dart';

class HiveHelper {
  static Future<void> init() async {
    var bucketsDir = Directory(GlobalConst.bucketsDataDir);
    if (!bucketsDir.existsSync()) {
      bucketsDir.createSync(recursive: true);
    }
    Hive.init(GlobalConst.bucketsDataDir);
  }

  static Future<Box> get bucketsBox async {
    var box = await Hive.openBox(HiveConst.bucketsBox);
    return box;
  }
}
