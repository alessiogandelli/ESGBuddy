/// Configuration file for backend endpoints
class AppConfig {
  // Production backend URL
  static const String baseUrl = 'https://esg.gandelli.dev/api';

  // API endpoints
  static const String companiesEndpoint = '/companies';
  static const String companyByCodeEndpoint = '/companies/by-code';
  static const String statsEndpoint = '/stats/summary';
}
