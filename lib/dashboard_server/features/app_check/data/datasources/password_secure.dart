import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';

class SecurePassword {
  final String _password;
  const SecurePassword(this._password);

  String getPasswordHash() {
    // creating random number
    var random = Random.secure();
    var res = random.nextInt(10000000);
    String randomMix = '${Uuid().v4()}$res';
    // creating a random salt
    List<int> saltBytes = utf8.encode(randomMix);
    // concatenating the salt with the password bytes
    final saltedPasswordBytes = utf8.encode(_password) + saltBytes;
    // hashing the salted password
    final hashedBytes = sha256.convert(saltedPasswordBytes).bytes;
    // encoding the salted password and the actual salt
    final encodedSalt = base64.encode(saltBytes);
    final encodedHash = base64.encode(hashedBytes);
    // returning the final result
    String finalResult = '$encodedSalt:$encodedHash';
    return finalResult;
  }

  bool checkPassword(String storedHash) {
    try {
      // Extract the salt and hashed password from the stored hash
      List<String> parts = storedHash.split(':');
      if (parts.length != 2) {
        // Incorrect hash format, handle the error
        return false;
      }

      String encodedSalt = parts[0];
      String encodedHash = parts[1];

      // Decode the salt and hashed password from base64
      List<int> saltBytes = base64.decode(encodedSalt);
      List<int> hashedBytes = base64.decode(encodedHash);

      // Concatenate the salt with the provided password
      List<int> saltedPasswordBytes = utf8.encode(_password) + saltBytes;

      // Hash the salted password using SHA-256
      List<int> computedHash = sha256.convert(saltedPasswordBytes).bytes;

      // Compare the computed hash with the stored hash
      if (computedHash.length != hashedBytes.length) {
        // Incorrect hash format, handle the error
        return false;
      }

      for (int i = 0; i < computedHash.length; i++) {
        if (computedHash[i] != hashedBytes[i]) {
          // Password mismatch, handle the error
          return false;
        }
      }

      // Password verification successful
      return true;
    } catch (e) {
      // Handle any other exceptions that may occur during the password verification process
      // print('Error occurred during password verification: $e');
      return false;
    }
  }
}
