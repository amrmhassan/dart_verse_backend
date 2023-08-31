import 'dart:io';

import 'package:dart_verse_backend/layers/services/storage_service/data/datasource/custom_isolate.dart';

void main(List<String> args) async {
  print('starting');
  CustomIsolate.compute((message) => copy(), null).then((value) {
    print(value);
  });
  print('after starting');
}

String copy() {
  File file = File('f:/video.mp4');
  file.copySync('f:/newVideo.mp4');
  return 'This file is copied';
}
