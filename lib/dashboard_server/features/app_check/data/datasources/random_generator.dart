import 'dart:math';

class RandomGenerator {
  String generate(int length) {
    final random = Random.secure();
    const charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    String apiKey = '';

    for (int i = 0; i < length; i++) {
      final randomIndex = random.nextInt(charset.length);
      apiKey += charset[randomIndex];
    }

    return apiKey;
  }
}
