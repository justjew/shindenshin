import 'base_config.dart';

abstract class BaseEnvironment<T extends BaseConfig> {
  static const String dev = 'DEV';
  static const String prod = 'PROD';

  late final T config;

  BaseEnvironment([String? forceEnv]) {
    String env = const String.fromEnvironment('ENVIRONMENT');
    if (env == '') {
      env = const String.fromEnvironment('ENV', defaultValue: dev);
    }
    config = getConfig(forceEnv ?? env);
  }

  T getConfig(String environment);
}
