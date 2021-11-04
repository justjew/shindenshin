import 'dart:async';
import 'dart:convert';
import 'dart:io' show WebSocket, WebSocketStatus;

import 'package:flutter/foundation.dart';

import 'api_client.dart';

class WebSocketService {
  WebSocketService(
    this.uri, {
    this.onReceive,
    this.onDone,
    this.onError,
    this.onConnecting,
    this.onConnected,
    this.onConnectionFail,
    this.reconnectIn = const Duration(seconds: 10),
  });

  final Uri uri;
  final void Function(WebSocketEventMessage)? onReceive;
  final void Function()? onDone;
  final void Function(dynamic)? onError;
  final void Function()? onConnecting;
  final void Function()? onConnected;
  final void Function(dynamic)? onConnectionFail;
  final Duration reconnectIn;
  StreamSubscription? _subscription;

  WebSocket? _ws;
  bool _isConnected = false;
  bool _reconnectOnDone = true;
  Timer? _reconnectionTimer;

  bool get isActive => _isConnected && _ws != null && _ws!.readyState == WebSocket.open;

  Future<void> connect() async {
    try {
      await _ws?.close(WebSocketStatus.goingAway);
      onConnecting?.call();
      _ws = await WebSocket.connect(uri.toString());
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
        if (kDebugMode) {
          // ignore: avoid_print
          print('[!]Connection Denied');
        }
        _isConnected = false;
        reconnect();
      }
    } on Exception catch (error) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[!]Error -- ${error.toString()}');
      }
      onConnectionFail?.call(error);
      reconnect();
    }
  }

  void reconnect() {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[!]Reconnecting in ${reconnectIn.inSeconds} sec...');
    }
    _reconnectionTimer = Timer(reconnectIn, connect);
  }

  void send(WebSocketEventMessage eventMessage) {
    _ws?.add(eventMessage.toString());
  }

  void _onReceive(dynamic event, void Function(WebSocketEventMessage)? onReceive) {
    final Map eventData = jsonDecode(event as String) as Map;
    onReceive?.call(WebSocketEventMessage(
      uuid: eventData['uuid'] as String,
      type: eventData['type'] as String,
      data: eventData['data'] as Map<String, dynamic>,
    ));
  }

  void _onDone() {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[+]Done :');
    }
    _isConnected = false;
    onDone?.call();
    if (_reconnectOnDone) {
      connect();
    }
  }

  void _onError(dynamic error) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[!]Error -- ${error.toString()}');
    }
    _isConnected = false;
    onError?.call(error);
    connect();
  }

  static Uri getBaseUri({required String path}) {
    final String scheme = kDebugMode ? 'ws' : 'wss';
    final Uri apiUri = ApiClient().getBaseUri();
    final String host = apiUri.host;
    final int port = apiUri.port;
    return Uri(scheme: scheme, host: host, port: port, path: '/ws/$path/');
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
  WebSocketEventMessage({required this.uuid, required this.type, required this.data});

  final String uuid;
  final String type;
  final Map<String, dynamic> data;

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
