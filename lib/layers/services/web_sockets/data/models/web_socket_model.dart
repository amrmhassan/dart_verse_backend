import 'dart:io';
import 'package:uuid/uuid.dart';

class WebSocketModel {
  final WebSocket webSocket;
  late final String id;
  late final DateTime connectedAt;
  final String? roomId;

  WebSocketModel({
    this.roomId,
    required this.webSocket,
  }) {
    connectedAt = DateTime.now();
    id = const Uuid().v4();
  }
}
