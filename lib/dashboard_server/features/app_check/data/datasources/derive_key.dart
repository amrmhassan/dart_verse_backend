// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:bcrypt/bcrypt.dart';
// import 'package:pointycastle/digests/sha256.dart';
// import 'package:pointycastle/key_derivators/api.dart';
// import 'package:pointycastle/key_derivators/pbkdf2.dart';
// import 'package:pointycastle/macs/hmac.dart';

// String deriveKeyFromSecret(String originalSecretKey) {
//   final iterations = 10000; // Number of iterations for PBKDF2
//   final keyLength = 32; // Desired derived key length (in bytes)
//   String bcryptSalt = BCrypt.gensalt();
//   print(bcryptSalt);
//   final salt = utf8.encode('BCrypt.gensalt()'); // Salt for PBKDF2

//   final pbkdf2 = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
//     ..init(Pbkdf2Parameters(Uint8List.fromList(salt), iterations, keyLength));

//   final derivedKey =
//       pbkdf2.process(Uint8List.fromList(utf8.encode(originalSecretKey)));

//   return base64.encode(derivedKey);
// }
