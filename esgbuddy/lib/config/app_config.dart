import 'local_config.dart';

/// Configuration file for backend endpoints
/// Change this to switch between different backends
class AppConfig {
  // Use local config for your personal backend URL (not committed to git)
  static const String baseUrl = LocalConfig.backendUrl;

  // Alternative: Use a public demo API or production URL
  // static const String baseUrl = 'https://api.yourdomain.com';

  // API endpoints
  static const String metricsEndpoint = '/metrics';
  static const String companiesEndpoint = '/companies';
}
