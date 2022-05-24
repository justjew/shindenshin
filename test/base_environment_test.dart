import 'package:shindenshin/shindenshin.dart';
import 'package:test/test.dart';

void main() {
  test('Correct getting config', () {
    final Environment env = Environment('PROD');
    expect(env.config is _ProdConfig, true);
    expect(env.config.apiUri.scheme, 'https');
  });

  test('Getting default config', () {
    final Environment envOther = Environment('OTHER');
    expect(envOther.config is _DevConfig, true);
    expect(envOther.config.apiUri.scheme, 'http');

    final Environment envEmpty = Environment();
    expect(envEmpty.config is _DevConfig, true);
    expect(envEmpty.config.apiUri.scheme, 'http');
  });
}

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
