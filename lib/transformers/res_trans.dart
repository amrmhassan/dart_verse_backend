import 'dart:convert';
import 'dart:io';

class ResTrans {
  final HttpResponse response;
  const ResTrans(this.response);

  void sendInvalidInput(String msg) {
    _sendRes(
      HttpStatus.badRequest,
      msg: msg,
    );
  }

  void sendForbiddenInput(String msg) {
    _sendRes(
      HttpStatus.forbidden,
      msg: msg,
    );
  }

  void sendInternalError(Object? msg) {
    _sendRes(
      HttpStatus.internalServerError,
      msg: msg,
    );
  }

  void sendSuccess(dynamic data, {bool jsonData = false}) {
    _sendRes(
      HttpStatus.ok,
      data: data,
      jsonData: jsonData,
    );
  }

  void _sendRes(
    int code, {
    Object? msg,
    dynamic data,
    bool jsonData = false,
  }) {
    var parsedData = jsonData ? json.encode(data) : data;

    response
      ..statusCode = code
      ..write({
        'code': code,
        'msg': msg.toString(),
        'data': parsedData,
      });
  }
}
