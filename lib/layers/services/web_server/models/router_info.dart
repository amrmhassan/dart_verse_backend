import 'package:dart_webcore/dart_webcore.dart';

class RouterInfo {
  final Router router;
  final bool jwtSecured;
  final bool emailMustBeVerified;
  final bool appIdSecured;

  const RouterInfo(
    this.router, {
    this.jwtSecured = false,
    this.appIdSecured = true,
    this.emailMustBeVerified = false,
  });
}
