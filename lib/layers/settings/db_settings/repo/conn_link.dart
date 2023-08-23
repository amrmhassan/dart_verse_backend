abstract class MongoDbConnLink {
  String get getConnLink;
}

abstract class MongoDbDNSConnLink implements MongoDbConnLink {}
// here i was supposed to add the classes for different ways to calc the conn link
// for example with ip, port no auth
// for example with ip, port auth
// for example with fullConnLink
// for example with dns host no auth
// for example with dns host auth
