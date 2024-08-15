import 'package:dart_verse_backend_new/dashboard_server/features/app_check/data/datasources/random_generator.dart';

class AppUtils {
  List<String> get _allowedLetters => charset.split('');
  static const String dashboardAppName = 'Verse Dashboard App';

  String appNameCleaner(String name) {
    String finalName = '';
    var letters = name.split('');
    for (var element in letters) {
      bool allowed = _allowedLetters.contains(element);
      if (allowed) {
        finalName += element;
      } else if (element == ' ') {
        finalName += '_';
      }
    }
    return finalName;
  }
}
