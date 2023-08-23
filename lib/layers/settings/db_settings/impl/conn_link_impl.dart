import '../repo/conn_link.dart';

class IpPortNoAuthConnLink implements MongoDbConnLink {
  final String ip;
  final int port;
  final String dbName;

  const IpPortNoAuthConnLink({
    required this.ip,
    required this.port,
    required this.dbName,
  });
  @override
  String get getConnLink => _getIpLinkNoAuth();

  String _getIpLinkNoAuth() {
    return 'mongodb://$ip:$port/$dbName';
  }
}

class IpPortWithAuthConnLink implements MongoDbConnLink {
  final String ip;
  final int port;
  final String dbName;
  final String userName;
  final String password;

  const IpPortWithAuthConnLink({
    required this.ip,
    required this.port,
    required this.dbName,
    required this.userName,
    required this.password,
  });
  @override
  String get getConnLink => _getIpLinkAuth();
  String _getIpLinkAuth() {
    return 'mongodb://$userName:$password@$ip:$port/$dbName';
  }
}

class FullConnLink implements MongoDbConnLink {
  final String connLink;
  const FullConnLink({
    required this.connLink,
  });
  @override
  String get getConnLink => connLink;
}

class DNSHostWithAuthConnLink implements MongoDbDNSConnLink {
  final String dbName;
  final String userName;
  final String password;
  final String dnsHost;
  const DNSHostWithAuthConnLink({
    required this.dbName,
    required this.userName,
    required this.password,
    required this.dnsHost,
  });
  @override
  String get getConnLink => _getIpLinkDNSAuth();
  String _getIpLinkDNSAuth() {
    return 'mongodb+srv://$userName:$password@$dnsHost/$dbName';
  }
}

class DNSHostNoAuthConnLink implements MongoDbDNSConnLink {
  final String dbName;
  final String dnsHost;
  const DNSHostNoAuthConnLink({
    required this.dbName,
    required this.dnsHost,
  });
  @override
  String get getConnLink => _getIpLinkDNSNoAuth();
  String _getIpLinkDNSNoAuth() {
    return 'mongodb+srv://$dnsHost/$dbName';
  }
}

class DNSHostFullLink implements MongoDbDNSConnLink {
  final String connLink;
  const DNSHostFullLink({
    required this.connLink,
  });
  @override
  String get getConnLink => connLink;
}
