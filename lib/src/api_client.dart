import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiClient {
  late final String releaseBaseHost;
  late final bool forceUseReleaseHost;
  late final String androidDegubHost;
  late final Dio client;
  late final BaseOptions options;
  ApiConfig config = ApiConfig();

  bool isInitialized = false;

  String? _access;
  String? _refresh;

  String? get access => _access;

  static final ApiClient _singleton = ApiClient._internal();

  factory ApiClient() {
    return _singleton;
  }

  ApiClient._internal();

  void init({
    required String releaseBaseHost,
    bool forceUseReleaseHost = false,
    String androidDegubHost = '10.0.2.2',
  }) {
    this.releaseBaseHost = releaseBaseHost;
    this.forceUseReleaseHost = forceUseReleaseHost;
    this.androidDegubHost = androidDegubHost;

    options = BaseOptions(
      baseUrl: getBaseUri().toString(),
      headers: {'Accept-Language': 'ru'},
      contentType: 'application/json',
    );
    client = Dio(options);
    isInitialized = true;
  }

  void setConfig(ApiConfig config) {
    this.config = config;
  }

  Future<Response> get(String action, {Map<String, dynamic>? params, bool protected = false}) {
    checkIfInitialized();
    return client.get(action, queryParameters: params, options: _getOptions(protected: protected));
  }

  Future<Response> post(String action, {dynamic body, bool protected = false}) {
    checkIfInitialized();
    return client.post(action, data: body, options: _getOptions(protected: protected));
  }

  Future<Response> put(String action, {dynamic body, bool protected = false}) {
    checkIfInitialized();
    return client.put(action, data: body, options: _getOptions(protected: protected));
  }

  Future<Response> delete(String action, {dynamic body, bool protected = false}) {
    checkIfInitialized();
    return client.delete(action, data: body, options: _getOptions(protected: protected));
  }

  Future<Response> download(
    String url,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
  }) {
    checkIfInitialized();
    final String _url = _reformatUrlIfInDebug(url);

    return client.download(_url, savePath, onReceiveProgress: onReceiveProgress);
  }

  void restoreToken() {
    final Box authBox = Hive.box('auth');
    if (!authBox.containsKey('access')) {
      throw NoStoredToken();
    }

    _access = authBox.get('access') as String?;
    _refresh = authBox.get('refresh') as String?;

    if (_access == null || _access!.isEmpty) {
      throw NoStoredToken();
    }
  }

  Uri getBaseUri() {
    String scheme;
    String host;
    int? port;

    const int _localPort = 8000;

    if (forceUseReleaseHost || kReleaseMode || kProfileMode) {
      scheme = 'https';
      host = releaseBaseHost;
    } else if (Platform.isAndroid) {
      scheme = 'http';
      host = androidDegubHost;
      port = _localPort;
    } else {
      scheme = 'http';
      host = '127.0.0.1';
      port = _localPort;
    }

    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: '/api/v1/',
    );
  }

  Future<void> login(String email, String password) async {
    try {
      final Response response = await post(
        'token/',
        body: {
          config.loginField: email,
          'password': password,
        },
      );
      final String access = response.data['access'] as String;
      final String refresh = response.data['refresh'] as String;
      _setToken(access, refresh);
    } on DioError catch (error) {
      if (error.response?.statusCode == HttpStatus.unauthorized) {
        throw BadCredentials();
      }
      rethrow;
    }
  }

  Future<void> refreshToken() async {
    if (_refresh == null) {
      throw UnableToRefreshToken();
    }

    final Response response = await post(
      '/token/refresh/',
      body: {'refresh': _refresh},
    );
    final String access = response.data['access'] as String;
    final String refresh = response.data['refresh'] as String;
    _setToken(access, refresh);
  }

  void logout() {
    _setToken(null);
  }

  void _setToken(String? access, [String? refresh]) {
    _access = access;
    _refresh = refresh;
    _saveToken();
  }

  void _saveToken() {
    Hive.box('auth').putAll({
      'access': _access,
      'refresh': _refresh,
    });
  }

  String _reformatUrlIfInDebug(String url) {
    if (kDebugMode && Platform.isAndroid) {
      return url.replaceFirst('127.0.0.1', '10.0.2.2');
    }

    return url;
  }

  Options _getOptions({required bool protected}) {
    if (protected && _access != null) {
      return Options(headers: {'Authorization': 'Bearer $_access'});
    }

    return Options();
  }

  void checkIfInitialized() {
    assert(isInitialized, 'ApiClient should be initialized. Call init() method.');
  }
}

class ApiConfig {
  final String loginField;

  ApiConfig({
    this.loginField = 'email',
  });
}

class NoStoredToken implements Exception {}

class BadCredentials implements Exception {}

class UnableToRefreshToken implements Exception {}
