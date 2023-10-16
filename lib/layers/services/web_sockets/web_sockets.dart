import 'dart:io';

import 'package:dart_verse_backend/layers/services/web_sockets/data/models/web_socket_model.dart';

//! this structure is the best for the users and rooms for broadcasting to rooms
//! and also good for sending a specific message to a specific user
//? Map<String, List<String>> rooms = {'roomId1':[userId1, userId2, userId3], 'roomId2':[userId1, userId2, userId3]}
//? Map<String, SocketModel> sockets = {'userId1':userSocketModel1, userId2:userSocketModel2 }
//! use this package for the socket client and server communication https://pub.dev/packages/socket_io_client {{{Better}}}
// you can use this instead https://pub.dev/packages/socket_io This is older
//! watch this video https://www.youtube.com/watch?v=OUlR2oXgRDs
//! also see this repo https://github.com/fullstack-yt/socketio-dart
class WebSockets {
  final HttpServer server;
  late Stream<WebSocket> webSocketServer;
  // final List<WebSocketModel> _sockets = [];

  WebSockets(this.server) {
    //
    webSocketServer = server.transform(WebSocketTransformer());
    webSocketServer.listen((WebSocket webSocket) {
      WebSocketModel socketModel = WebSocketModel(webSocket: webSocket);
      webSocket.add(socketModel.id);
    });
  }
}
