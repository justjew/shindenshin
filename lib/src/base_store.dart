import 'package:shindenshin/src/api_client.dart';
import 'package:shindenshin/src/subscriptable.dart';

import 'base_repo.dart';

abstract class BaseStore extends Subscriptable {
  final String releaseBaseHost;

  final List<BaseRepo> repos = [];

  BaseStore(List<BaseRepo Function()> _contructors, {required this.releaseBaseHost}) {
    _registerRepos(_contructors);
    initApiClient();
  }

  void initApiClient() {
    ApiClient().init(releaseBaseHost: releaseBaseHost);
  }

  T get<T extends BaseRepo>() {
    return repos.singleWhere((e) => e is T) as T;
  }

  T call<T extends BaseRepo>() {
    return get<T>();
  }

  void dispose() {
    _disposeAllRepos();
  }

  void _registerRepos(List<Function()> _contructors) {
    for (final c in _contructors) {
      repos.add(c());
    }
  }

  void _disposeAllRepos() {
    for (final repo in repos) {
      repo.dispose();
    }
  }
}
