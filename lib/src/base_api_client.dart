import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseApiClient {
  final Dio client;
  String? _access;

  BaseApiClient(this.client);

  void setAccessToken(String? token) {
    _access = token;
  }

  Future<Response> get(
    String action, {
    Map<String, dynamic>? params,
    bool protected = false,
  }) {
    return client.get(
      action,
      queryParameters: params,
      options: _getOptions(protected: protected),
    );
  }

  Future<Response> post(
    String action, {
    dynamic body,
    bool protected = false,
  }) {
    return client.post(
      action,
      data: body,
      options: _getOptions(protected: protected),
    );
  }

  Future<Response> put(
    String action, {
    dynamic body,
    bool protected = false,
  }) {
    return client.put(
      action,
      data: body,
      options: _getOptions(protected: protected),
    );
  }

  Future<Response> delete(
    String action, {
    dynamic body,
    bool protected = false,
  }) {
    return client.delete(
      action,
      data: body,
      options: _getOptions(protected: protected),
    );
  }

  Future<Response> download(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
  }) {
    final String _url = _reformatUrlIfInDebug(url);

    return client.download(
      _url,
      savePath,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Options _getOptions({required bool protected}) {
    if (protected && _access != null) {
      return Options(headers: {'Authorization': 'Bearer $_access'});
    }

    return Options();
  }

  String _reformatUrlIfInDebug(String url) {
    if (kDebugMode && Platform.isAndroid) {
      return url.replaceFirst('127.0.0.1', '10.0.2.2');
    }

    return url;
  }
}
