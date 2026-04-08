enum Environment { dev, staging, prod }

class EnvConfig {
  EnvConfig._({
    required this.environment,
    required this.apiBaseUrl,
    required this.appName,
    required this.enableLogging,
  });

  factory EnvConfig.fromEnvironment(Environment env) {
    return switch (env) {
      Environment.dev => EnvConfig._(
          environment: Environment.dev,
          apiBaseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://dev-api.example.com',
          ),
          appName: 'FlutterStarter (Dev)',
          enableLogging: true,
        ),
      Environment.staging => EnvConfig._(
          environment: Environment.staging,
          apiBaseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://staging-api.example.com',
          ),
          appName: 'FlutterStarter (Staging)',
          enableLogging: true,
        ),
      Environment.prod => EnvConfig._(
          environment: Environment.prod,
          apiBaseUrl: const String.fromEnvironment(
            'API_BASE_URL',
            defaultValue: 'https://api.example.com',
          ),
          appName: 'FlutterStarter',
          enableLogging: false,
        ),
    };
  }

  static EnvConfig? _instance;

  static EnvConfig get instance {
    final i = _instance;
    if (i == null) {
      throw StateError(
        'EnvConfig.initialize() must be called before accessing instance. '
        'Ensure it is called in main() before runApp().',
      );
    }
    return i;
  }

  static void initialize(Environment env) {
    _instance = EnvConfig.fromEnvironment(env);
  }

  final Environment environment;
  final String apiBaseUrl;
  final String appName;
  final bool enableLogging;

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}
