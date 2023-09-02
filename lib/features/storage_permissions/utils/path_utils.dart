import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class PathUtils {
  // Function to generate a 32-bit hash representation for a file path.
  static int filePathHash(String filePath) {
    // Convert the file path to bytes.
    Uint8List bytes = Uint8List.fromList(utf8.encode(filePath));

    // Calculate a hash of the bytes using a cryptographic hash function (SHA-256).
    Digest digest = sha256.convert(bytes);

    // Take the first 4 bytes of the digest as a 32-bit integer.
    int hashValue = Uint8List.fromList(digest.bytes.sublist(0, 4))
        .buffer
        .asByteData()
        .getInt32(0);

    return hashValue.abs();
  }
}
