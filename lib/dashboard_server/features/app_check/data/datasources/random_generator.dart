import 'dart:math';

const charset =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

class RandomGenerator {
  String generate(int length) {
    final random = Random.secure();

    String apiKey = '';

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(charset.length);
      apiKey += charset[randomIndex];
    }

    return apiKey;
  }
}
