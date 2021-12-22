import 'package:shindenshin/src/api_client.dart';
import 'package:shindenshin/src/subscriptable.dart';

import 'base_repo.dart';

abstract class BaseStore extends Subscriptable {
  final String releaseBaseHost;
  final bool forceUseReleaseHost;
  final String androidDegubHost;

  final List<BaseRepo> repos = [];

  BaseStore(
    List<BaseRepo Function(BaseStore)> _contructors, {
    required this.releaseBaseHost,
    this.forceUseReleaseHost = false,
    this.androidDegubHost = '10.0.2.2',
  }) {
    _registerRepos(_contructors);
    initApiClient();
  }

  void initApiClient() {
    ApiClient().init(
      releaseBaseHost: releaseBaseHost,
      forceUseReleaseHost: forceUseReleaseHost,
      androidDegubHost: androidDegubHost,
    );
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

  void _registerRepos(List<BaseRepo Function(BaseStore)> _contructors) {
    for (final c in _contructors) {
      repos.add(c(this));
    }
  }

  void _disposeAllRepos() {
    for (final repo in repos) {
      repo.dispose();
    }
  }
}
