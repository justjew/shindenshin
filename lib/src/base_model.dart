import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'api_client.dart';
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

  const BaseModel(this.id);

  Map toJson();
}

abstract class BaseModelApi<T extends BaseModel> {
  abstract String url;
  final ApiClient _apiClient = ApiClient();

  final bool rootList = false;

  T fromJson(Map json);

  List<T> fromList(List list) {
    return list.map((e) => fromJson(e)).toList();
  }

  Future<T> retrieve(dynamic id, {bool protected = false}) async {
    final Response response = await get(id.toString(), protected: protected);
    final Map data = response.data as Map;

    return fromJson(data);
  }

  Future<List<T>> list({Map<String, dynamic>? params, bool protected = false}) async {
    if (rootList) {
      final Response response = await get('', params: params, protected: protected);
      final List results = response.data;
      return results.map((e) => fromJson(e as Map)).toList();
    }

    final Pagination<T> pagination = await listPaginated(params: params, protected: protected);
    return pagination.results;
  }

  Future<Pagination<T>> listPaginated({
    Map<String, dynamic>? params,
    bool protected = false,
  }) async {
    final Response response = await get('', params: params, protected: protected);
    final dynamic data = response.data;

    return Pagination.fromJson(data, fromJson);
  }

  Future<T> create(T source, {bool protected = true}) async {
    final Response response = await post('', body: source.toJson(), protected: protected);
    final Map data = response.data as Map;

    return fromJson(data);
  }

  Future<T> update(T source, {bool protected = true}) async {
    final Response response = await put(
      '/${source.id}',
      body: source.toJson(),
      protected: protected,
    );
    final Map data = response.data as Map;

    return fromJson(data);
  }

  Future<void> detele(dynamic id, {dynamic body, bool protected = true}) {
    return delete('/$id', body: body, protected: protected);
  }

  Future<Response> get(String action, {Map<String, dynamic>? params, bool protected = false}) {
    return _apiClient.get('$url$action/', params: params, protected: protected);
  }

  Future<Response> post(String action, {dynamic body, bool protected = true}) {
    return _apiClient.post('$url$action/', body: body, protected: protected);
  }

  Future<Response> put(String action, {dynamic body, bool protected = true}) {
    return _apiClient.put('$url$action/', body: body, protected: protected);
  }

  Future<Response> delete(String action, {dynamic body, bool protected = true}) {
    return _apiClient.delete('$url$action/', body: body, protected: protected);
  }
}
