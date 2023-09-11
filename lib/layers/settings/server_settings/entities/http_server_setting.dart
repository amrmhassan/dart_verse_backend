import 'dart:io';

class HttpServerSetting {
  final InternetAddress address;
  final int port;
  final SecurityContext? context;
  final int backlog;
  final bool v6Only;
  final bool requestClientCertificate;
  final bool shared;

  const HttpServerSetting(
    this.address,
    this.port, {
    this.context,
    this.backlog = 0,
    this.requestClientCertificate = false,
    this.shared = false,
    this.v6Only = false,
  });
}
