import 'package:dart_webcore_new/dart_webcore_new.dart';

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
