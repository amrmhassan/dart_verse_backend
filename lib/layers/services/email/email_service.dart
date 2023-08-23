import 'dart:io';

import 'package:dart_verse_backend/errors/models/email_exceptions.dart';
import 'package:dart_verse_backend/layers/settings/app/app.dart';
import 'package:mailer/mailer.dart';

import 'package:html/parser.dart' as parser;

class EmailService {
  final App _app;
  late PersistentConnection _connection;
  EmailService(this._app) {
    _connection = PersistentConnection(_app.emailSettings.server);
  }

  Future<SendReport> sendMessage(Message message) {
    return _connection.send(message);
  }

  /// this will convert the email template into a message content
  /// don't add text or html because they will be replaced by the template
  /// `template file can be in any format, html, txt or whatever`
  ///  template value should be on format `</valueKeyHere/>`
  /// and you just need to replace the valueKeyHere with the actual value in the values object in this function
  Future<SendReport> sendFromTemplateFile(
    Message message,
    String templateFilePath,
    Map<String, String> values,
  ) async {
    File file = File(templateFilePath);
    if (!file.existsSync()) {
      throw TemplateNotFoundException();
    }
    String fileContent = await file.readAsString();
    return sendFromTemplateText(message, fileContent, values);
  }

  Future<SendReport> sendFromTemplateText(
    Message message,
    String templateString,
    Map<String, String> values,
  ) {
    // here start parsing the template file
    values.forEach((key, value) {
      String keyTemp = keyFormat(key);
      templateString = templateString.replaceAll(keyTemp, value);
    });
    String htmlContent = templateString;
    String normalContent = _parseHtmlString(htmlContent);
    message
      ..text = normalContent
      ..html = htmlContent;
    return sendMessage(message);
  }

  Future<void> closeServer() {
    return _connection.close();
  }

  String keyFormat(String key) {
    return '[/$key/]';
  }

  String _parseHtmlString(String htmlString) {
    final document = parser.parse(htmlString);
    var body = document.body;
    if (body == null) return '';
    var documentElement = parser.parse(body.text).documentElement;
    if (documentElement == null) return '';
    final String parsedString = documentElement.text.trim();

    return parsedString;
  }
}
