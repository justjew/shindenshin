import 'package:shindenshin/src/base_api_client.dart';
import 'package:shindenshin/src/subscriptable.dart';

import 'base_repo.dart';

abstract class BaseStore extends Subscriptable {
  final BaseApiClient apiClient;
  final Set<BaseRepo> repos = {};

  final Set<BaseRepo> _tempRepos = {};

  BaseStore(this.apiClient, List<BaseRepo Function(BaseStore)> _contructors) {
    registerRepos(_contructors);
  }

  T get<T extends BaseRepo>() {
    return repos.singleWhere((e) => e is T) as T;
  }

  T call<T extends BaseRepo>() {
    return get<T>();
  }

  void registerRepos(List<BaseRepo Function(BaseStore)> _contructors) {
    for (final c in _contructors) {
      final BaseRepo repo = c(this);
      final Type type = repo.runtimeType;

      if (repos.where((e) => e.runtimeType == type).isNotEmpty) {
        return;
      }

      repos.add(repo);
    }

    for (final repo in repos) {
      repo.onRegisterComplete();
    }
  }

  T getTempRepo<T extends BaseRepo>(T Function(BaseStore) constructor) {
    if (_tempRepos.whereType<T>().isNotEmpty) {
      return _tempRepos.singleWhere((e) => e is T) as T;
    }

    final T repo = constructor(this);
    _tempRepos.add(repo);
    return repo;
  }

  void disposeTempRepo<T>() {
    if (_tempRepos.whereType<T>().isEmpty) {
      return;
    }
    _tempRepos.singleWhere((e) => e is T).dispose();
    _tempRepos.removeWhere((e) => e is T);
  }

  bool contains<T>() {
    return repos.whereType<T>().isNotEmpty;
  }

  void dispose() {
    _disposeAllRepos();
  }

  void _disposeAllRepos() {
    for (final repo in repos) {
      repo.dispose();
    }
  }
}
