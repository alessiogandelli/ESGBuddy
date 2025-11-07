import '../models/esg_metric.dart';
import '../models/company_profile.dart';
import 'api_service.dart';
import 'i_esg_repository.dart';

/// Repository for ESG-related data
/// Acts as an abstraction layer between the data source and the presentation layer
/// This makes it easy to swap backends without changing UI code
class EsgRepository implements IEsgRepository {
  final ApiService apiService;

  EsgRepository({required this.apiService});

  /// Fetch all ESG metrics
  @override
  Future<List<EsgMetric>> getMetrics() async {
    try {
      final data = await apiService.get('/metrics');

      // Handle both single object and array responses
      if (data is List) {
        return data.map((json) => EsgMetric.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        // If n8n returns a single object or nested structure
        if (data.containsKey('metrics')) {
          return (data['metrics'] as List)
              .map((json) => EsgMetric.fromJson(json))
              .toList();
        }
        return [EsgMetric.fromJson(data)];
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch metrics: $e');
    }
  }

  /// Fetch a single metric by ID
  @override
  Future<EsgMetric?> getMetricById(String id) async {
    try {
      final data = await apiService.get('/metrics/$id');
      return EsgMetric.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch metric: $e');
    }
  }

  /// Create a new metric
  @override
  Future<EsgMetric> createMetric(EsgMetric metric) async {
    try {
      final data = await apiService.post('/metrics', metric.toJson());
      return EsgMetric.fromJson(data);
    } catch (e) {
      throw Exception('Failed to create metric: $e');
    }
  }

  /// Fetch company profile
  @override
  Future<CompanyProfile?> getCompanyProfile(String companyId) async {
    try {
      final data = await apiService.get('/companies/$companyId');
      return CompanyProfile.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch company profile: $e');
    }
  }

  /// Fetch all companies
  @override
  Future<List<CompanyProfile>> getCompanies() async {
    try {
      final data = await apiService.get('/companies');

      if (data is List) {
        return data.map((json) => CompanyProfile.fromJson(json)).toList();
      } else if (data is Map<String, dynamic>) {
        if (data.containsKey('companies')) {
          return (data['companies'] as List)
              .map((json) => CompanyProfile.fromJson(json))
              .toList();
        }
        return [CompanyProfile.fromJson(data)];
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }
}
