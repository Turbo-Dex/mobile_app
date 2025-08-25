/// Compile-time env (via --dart-define)
class AppEnv {
  /// TODO : set API URL
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000', // Default emulator value
  );
}
