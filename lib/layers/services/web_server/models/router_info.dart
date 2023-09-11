import 'package:dart_webcore/dart_webcore.dart';

class RouterInfo {
  final Router router;
  final bool jwtSecured;
  final bool emailMustBeVerified;

  const RouterInfo(
    this.router, {
    this.jwtSecured = false,
    this.emailMustBeVerified = false,
  });
}
