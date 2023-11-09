import 'package:dio/dio.dart';
import 'package:shindenshin/src/exceptions.dart';

import 'base_api_client.dart';
import 'pagination.dart';

abstract class BaseModel {
  const BaseModel();
}

abstract class BaseModelParser<T extends BaseModel> {
  T fromJson(Map<String, Object?> json);

  List<T> fromList(List list) {
    return list.cast<Map<String, Object?>>().map((e) => fromJson(e)).toList();
  }
}

abstract class BaseModelApi<T extends BaseModel> {
  final BaseModelParser<T> parser;
  final BaseApiClient apiClient;

  String get url => throw ModelApiUrlNotImplemented();

  BaseModelApi(
    this.apiClient,
    this.parser,
  );

  Future<T> retrieve(
    dynamic id, {
    bool protected = false,
    bool verbose = false,
  }) async {
    final Response response = await get(
      '/${id.toString()}',
      protected: protected,
      verbose: verbose,
    );
    final Map<String, Object?> data = response.data;

    return parser.fromJson(data);
  }

  Future<List<T>> list({
    Map<String, dynamic>? params,
    bool protected = false,
    bool rootList = false,
    bool verbose = false,
  }) async {
    if (rootList) {
      final Response response = await get(
        '',
        params: params,
        protected: protected,
        verbose: verbose,
      );
      final List results = response.data;
      return results.map((e) => parser.fromJson(e)).toList();
    }

    final Pagination<T> pagination =
        await listPaginated(params: params, protected: protected);
    return pagination.results;
  }

  Future<Pagination<T>> listPaginated({
    Map<String, dynamic>? params,
    bool protected = false,
    bool verbose = false,
  }) async {
    final Response response = await get(
      '',
      params: params,
      protected: protected,
      verbose: verbose,
    );
    final dynamic data = response.data;

    return Pagination.fromJson(data, parser.fromJson);
  }

  Future<T> create(
    Map source, {
    bool protected = true,
    bool verbose = false,
  }) async {
    final Response response = await post(
      '',
      body: source,
      protected: protected,
      verbose: verbose,
    );
    final Map<String, Object?> data = response.data;

    return parser.fromJson(data);
  }

  Future<T> update(
    dynamic id,
    Map source, {
    bool protected = true,
    bool verbose = false,
  }) async {
    final Response response = await put(
      '/$id',
      body: source,
      protected: protected,
      verbose: verbose,
    );
    final Map<String, Object?> data = response.data;

    return parser.fromJson(data);
  }

  Future<void> destroy(
    dynamic id, {
    dynamic body,
    bool protected = true,
    bool verbose = false,
  }) {
    return delete(
      '/$id',
      body: body,
      protected: protected,
      verbose: verbose,
    );
  }

  Future<Response<K>> get<K>(
    String action, {
    Map<String, dynamic>? params,
    bool protected = false,
    void Function(int, int)? onReceiveProgress,
    bool verbose = false,
  }) {
    return apiClient.get<K>(
      '$url$action/',
      params: params,
      protected: protected,
      onReceiveProgress: onReceiveProgress,
      verbose: verbose,
    );
  }

  Future<Response<K>> post<K>(
    String action, {
    dynamic body,
    bool protected = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool verbose = false,
  }) {
    return apiClient.post<K>(
      '$url$action/',
      body: body,
      protected: protected,
      verbose: verbose,
    );
  }

  Future<Response<K>> put<K>(
    String action, {
    dynamic body,
    bool protected = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    bool verbose = false,
  }) {
    return apiClient.put<K>(
      '$url$action/',
      body: body,
      protected: protected,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      verbose: verbose,
    );
  }

  Future<Response<K>> delete<K>(
    String action, {
    dynamic body,
    bool protected = true,
    bool verbose = false,
  }) {
    return apiClient.delete<K>(
      '$url$action/',
      body: body,
      protected: protected,
      verbose: verbose,
    );
  }
}
