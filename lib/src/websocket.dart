import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket, WebSocketStatus;

import 'package:flutter/foundation.dart';

class WebSocketService {
  final Uri uri;
  final void Function(WebSocketEventMessage)? onReceive;
  final void Function()? onDone;
  final void Function(dynamic)? onError;
  final void Function()? onConnecting;
  final void Function()? onConnected;
  final void Function(dynamic)? onConnectionFail;
  final Duration reconnectIn;
  StreamSubscription? _subscription;
  Map<String, dynamic>? headers;

  WebSocketService(
    this.uri, {
    this.onReceive,
    this.onDone,
    this.onError,
    this.onConnecting,
    this.onConnected,
    this.onConnectionFail,
    this.reconnectIn = const Duration(seconds: 10),
    this.headers,
  });

  WebSocket? _ws;
  bool _isConnected = false;
  bool _reconnectOnDone = true;
  Timer? _reconnectionTimer;

  bool get isActive => _isConnected && _ws != null && _ws!.readyState == WebSocket.open;

  Future<void> connect() async {
    try {
      await _ws?.close(WebSocketStatus.goingAway);
      onConnecting?.call();
      _ws = await WebSocket.connect(
        uri.toString(),
        headers: headers,
      );
      _ws!.pingInterval = const Duration(seconds: 10);

      if (_ws?.readyState == WebSocket.open) {
        _isConnected = true;
        _subscription = _ws!.listen(
          (event) => _onReceive(event, onReceive),
          onDone: _onDone,
          onError: _onError,
          cancelOnError: true,
        );
        onConnected?.call();
      } else {
        debugPrint('[!]Connection Denied');
        _isConnected = false;
        reconnect();
      }
    } on Exception catch (error) {
      debugPrint('[!]Error -- ${error.toString()}');
      onConnectionFail?.call(error);
      reconnect();
    }
  }

  void reconnect() {
    debugPrint('[!]Reconnecting in ${reconnectIn.inSeconds} sec...');
    _reconnectionTimer = Timer(reconnectIn, connect);
  }

  void send(WebSocketEventMessage eventMessage) {
    _ws?.add(eventMessage.toString());
  }

  void _onReceive(dynamic event, void Function(WebSocketEventMessage)? onReceive) {
    final Map eventData = jsonDecode(event as String) as Map;
    onReceive?.call(WebSocketEventMessage(
      uuid: eventData['uuid'],
      type: eventData['type'],
      data: eventData['data'],
    ));
  }

  void _onDone() {
    debugPrint('[+]Done :');
    _isConnected = false;
    onDone?.call();
    if (_reconnectOnDone) {
      connect();
    }
  }

  void _onError(dynamic error) {
    debugPrint('[!]Error -- ${error.toString()}');
    _isConnected = false;
    onError?.call(error);
    connect();
  }

  void close() {
    _reconnectionTimer?.cancel();
    _subscription?.cancel();
    _reconnectOnDone = false;
    _ws?.close(WebSocketStatus.goingAway);
    _ws = null;
    _isConnected = false;
    _reconnectOnDone = true;
  }
}

class WebSocketEventMessage {
  WebSocketEventMessage({
    required this.uuid,
    required this.type,
    required this.data,
  });

  final String? uuid;
  final String? type;
  final dynamic data;

  Map toJson() {
    return {
      'uuid': uuid,
      'type': type,
      'data': data,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class WebSocketNotCreated implements Exception {}

class WebSocketNotOpen implements Exception {}
