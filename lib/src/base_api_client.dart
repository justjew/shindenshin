import 'dart:io';
import 'dart:convert';

import 'package:ansicolor/ansicolor.dart';
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

  Future<Response<T>> get<T>(
    String action, {
    Map<String, dynamic>? params,
    bool protected = false,
    void Function(int, int)? onReceiveProgress,
    bool verbose = false,
  }) async {
    try {
      final Response<T> response = await client.get<T>(
        action,
        queryParameters: params,
        options: getOptions(protected: protected),
        onReceiveProgress: onReceiveProgress,
      );

      _verboseResponse(response, verbose);
      return response;
    } on DioException catch (error) {
      _verboseResponse(error.response as Response<T>, verbose);
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String action, {
    dynamic body,
    bool protected = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool verbose = false,
  }) async {
    try {
      final Response response = await client.post<T>(
        action,
        data: body,
        options: getOptions(protected: protected),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      _verboseResponse(response, verbose);
      return response as Response<T>;
    } on DioException catch (error) {
      _verboseResponse(error.response as Response<T>, verbose);
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String action, {
    dynamic body,
    bool protected = false,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool verbose = false,
  }) async {
    try {
      final Response response = await client.put<T>(
        action,
        data: body,
        options: getOptions(protected: protected),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      _verboseResponse(response, verbose);
      return response as Response<T>;
    } on DioException catch (error) {
      _verboseResponse(error.response as Response<T>, verbose);
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String action, {
    dynamic body,
    bool protected = false,
    bool verbose = false,
  }) async {
    try {
      final Response response = await client.delete<T>(
        action,
        data: body,
        options: getOptions(protected: protected),
      );

      _verboseResponse(response, verbose);
      return response as Response<T>;
    } on DioException catch (error) {
      _verboseResponse(error.response as Response<T>, verbose);
      rethrow;
    } catch (_) {
      rethrow;
    }
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

  void _verboseResponse(Response response, bool verbose) {
    if (!verbose) {
      return;
    }

    const JsonEncoder encoder = JsonEncoder.withIndent('  ');

    final AnsiPen greenPen = AnsiPen()..green(bold: true);
    final AnsiPen redPen = AnsiPen()..red(bold: true);
    final AnsiPen bluePen = AnsiPen()..blue(bold: true);
    final AnsiPen yellowPen = AnsiPen()..yellow(bold: true);
    final AnsiPen grayPen = AnsiPen()..gray();

    debugPrint('\n\n${greenPen('API request')} \n');
    debugPrint(grayPen(DateTime.now().toIso8601String()));
    debugPrint(bluePen('Request:'));
    debugPrint(
      '${response.requestOptions.method} - ${response.requestOptions.uri.toString()}',
    );

    debugPrint(bluePen('Headers:'));
    debugPrint(encoder.convert(response.requestOptions.headers));

    debugPrint(bluePen('Data:'));
    Map requestData = {};
    if (response.requestOptions.method.toLowerCase() == 'get') {
      requestData = response.requestOptions.queryParameters;
    } else if (response.requestOptions.data is Map) {
      requestData = response.requestOptions.data;
    } else {
      print(yellowPen('Binary request data'));
    }
    debugPrint(encoder.convert(requestData));

    debugPrint('\n\n${greenPen('Response')} \n');
    if (![200, 201, 204].contains(response.statusCode)) {
      debugPrint(redPen('WITH ERROR'));
    }
    debugPrint('${bluePen('Status code:')} ${response.statusCode}');

    debugPrint(bluePen('Data:'));
    final Map responseData = response.data is Map ? response.data as Map : {};
    debugPrint(encoder.convert(responseData));
    debugPrint('\n\n');
  }
}
