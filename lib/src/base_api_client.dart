import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class BaseApiClient {
  final Dio client;
  String? _access;
  String acceptLanguage;

  BaseApiClient(
    this.client, {
    this.acceptLanguage = 'ru-ru',
  });

  void setAccessToken(String? token) {
    _access = token;
  }

  Future<Response> get(
    String action, {
    Map<String, dynamic>? params,
    bool protected = false,
    void Function(int, int)? onReceiveProgress,
  }) {
    return client.get(
      action,
      queryParameters: params,
      options: getOptions(protected: protected),
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> post(
    String action, {
    dynamic body,
    bool protected = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return client.post(
      action,
      data: body,
      options: getOptions(protected: protected),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> put(
    String action, {
    dynamic body,
    bool protected = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return client.put(
      action,
      data: body,
      options: getOptions(protected: protected),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
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
      options: getOptions(protected: protected),
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

  Options getOptions({required bool protected}) {
    Map<String, dynamic> headers = {
      'Accept-Language': acceptLanguage,
    };
    Options options = Options(headers: headers);
    if (!protected || _access == null) {
      return options;
    }

    headers.addAll({
      'Authorization': 'Bearer $_access',
    });
    return options.copyWith(headers: headers);
  }

  String _reformatUrlIfInDebug(String url) {
    if (kDebugMode && Platform.isAndroid) {
      return url.replaceFirst('127.0.0.1', '10.0.2.2');
    }

    return url;
  }
}
