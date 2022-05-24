import 'package:shindenshin/shindenshin.dart';

class Environment extends BaseEnvironment<_Config> {
  Environment([String? environment]) : super(environment);

  @override
  _Config getConfig(String environment) {
    switch (environment) {
      case BaseEnvironment.prod:
        return _ProdConfig();
      default:
        return _DevConfig();
    }
  }
}

abstract class _Config extends BaseConfig {
  Uri get wsUri;
  String get sentryDSN;
}

class _ProdConfig extends _Config {
  @override
  Uri get apiUri => Uri(scheme: 'https', host: 'google.com');

  @override
  String get sentryDSN => 'sentry_dsn';

  @override
  Uri get wsUri => Uri(scheme: 'wss', host: 'google.com');
}

class _DevConfig extends _Config {
  @override
  Uri get apiUri => Uri(scheme: 'http', host: 'localhost');

  @override
  String get sentryDSN => '';

  @override
  Uri get wsUri => Uri(scheme: 'ws', host: 'localhost');
}
