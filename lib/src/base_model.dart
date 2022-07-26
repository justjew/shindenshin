import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'base_api_client.dart';
import 'pagination.dart';

/// A base class to create models
///
/// A model has [id] by default which is [dynamic] type. It allows [id] to be integer, uuid etc.
/// Need to implement [toJson] method.
abstract class BaseModel extends Equatable {
  @HiveField(0)
  final dynamic id;

  @override
  List<Object?> get props => [id];

  const BaseModel({required this.id});

  Map toJson();
}

abstract class BaseModelParser<T extends BaseModel> {
  T fromJson(Map json);

  List<T> fromList(List list) {
    return list.map((e) => fromJson(e)).toList();
  }
}

abstract class BaseModelApi<T extends BaseModel> {
  final BaseModelParser<T> parser;
  final BaseApiClient apiClient;
  final bool rootList = false;

  String get url;

  BaseModelApi(this.apiClient, this.parser);

  Future<T> retrieve(dynamic id, {bool protected = false}) async {
    final Response response = await get('/${id.toString()}', protected: protected);
    final Map data = response.data as Map;

    return parser.fromJson(data);
  }

  Future<List<T>> list(
      {Map<String, dynamic>? params, bool protected = false}) async {
    if (rootList) {
      final Response response =
          await get('', params: params, protected: protected);
      final List results = response.data;
      return results.map((e) => parser.fromJson(e as Map)).toList();
    }

    final Pagination<T> pagination =
        await listPaginated(params: params, protected: protected);
    return pagination.results;
  }

  Future<Pagination<T>> listPaginated({
    Map<String, dynamic>? params,
    bool protected = false,
  }) async {
    final Response response =
        await get('', params: params, protected: protected);
    final dynamic data = response.data;

    return Pagination.fromJson(data, parser.fromJson);
  }

  Future<T> create(T source, {bool protected = true}) async {
    final Response response =
        await post('', body: source.toJson(), protected: protected);
    final Map data = response.data as Map;

    return parser.fromJson(data);
  }

  Future<T> update(T source, {bool protected = true}) async {
    final Response response = await put(
      '/${source.id}',
      body: source.toJson(),
      protected: protected,
    );
    final Map data = response.data as Map;

    return parser.fromJson(data);
  }

  Future<void> destroy(dynamic id, {dynamic body, bool protected = true}) {
    return delete('/$id', body: body, protected: protected);
  }

  Future<Response> get(
    String action, {
    Map<String, dynamic>? params,
    bool protected = false,
    void Function(int, int)? onReceiveProgress,
  }) {
    return apiClient.get(
      '$url$action/',
      params: params,
      protected: protected,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> post(
    String action, {
    dynamic body,
    bool protected = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return apiClient.post(
      '$url$action/',
      body: body,
      protected: protected,
    );
  }

  Future<Response> put(
    String action, {
    dynamic body,
    bool protected = true,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) {
    return apiClient.put(
      '$url$action/',
      body: body,
      protected: protected,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> delete(
    String action, {
    dynamic body,
    bool protected = true,
  }) {
    return apiClient.delete(
      '$url$action/',
      body: body,
      protected: protected,
    );
  }
}
