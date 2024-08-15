import 'package:dart_verse_backend_new/layers/settings/db_settings/impl/conn_link_impl.dart';
import 'package:dart_verse_backend_new/layers/settings/db_settings/repo/conn_link.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv(includePlatformEnvironment: true)..load();

MongoDbConnLink cloudsConnLink = IpPortWithAuthConnLink(
  ip: env['DBIP'].toString(),
  port: int.parse(env['DBPORT'].toString()),
  dbName: 'admin',
  userName: env['DBUSERNAME'].toString(),
  password: env['DBPASSWORD'].toString(),
);
MongoDbConnLink atlasConnLink = DNSHostFullLink(
  connLink: env['REMOTECONNLINK'].toString(),
);
MongoDbConnLink localConnLinkReplica = const DNSHostFullLink(
  connLink: 'mongodb://localhost:27017/?replicaSet=rs0',
);
MongoDbConnLink localConnLink = const DNSHostFullLink(
  connLink: 'mongodb://localhost:27017',
);
MongoDbConnLink dashboardConnLink = const DNSHostFullLink(
  connLink: 'mongodb://localhost:27017/dashboard',
);
