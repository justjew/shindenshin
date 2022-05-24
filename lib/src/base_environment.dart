import 'base_config.dart';

abstract class BaseEnvironment<T extends BaseConfig> {
  static const String dev = 'DEV';
  static const String prod = 'PROD';

  late final T config;

  BaseEnvironment([String? environment]) {
    config = getConfig(environment ??
        const String.fromEnvironment(
          'ENVIRONMENT',
          defaultValue: dev,
        ));
  }

  T getConfig(String environment);
}
