import '../models/esg_metric.dart';
import '../models/company_profile.dart';
import 'i_esg_repository.dart';

/// Mock repository for testing without backend
/// Useful during hackathon when backend isn't ready
class MockEsgRepository implements IEsgRepository {
  /// Get mock ESG metrics
  @override
  Future<List<EsgMetric>> getMetrics() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      EsgMetric(
        id: '1',
        name: 'Carbon Emissions',
        category: 'Environmental',
        value: 1250.5,
        unit: 'tons CO2',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      EsgMetric(
        id: '2',
        name: 'Employee Satisfaction',
        category: 'Social',
        value: 85.3,
        unit: '%',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      EsgMetric(
        id: '3',
        name: 'Board Diversity',
        category: 'Governance',
        value: 42.0,
        unit: '%',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      EsgMetric(
        id: '4',
        name: 'Water Usage',
        category: 'Environmental',
        value: 5420.0,
        unit: 'm³',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }

  /// Get mock metric by ID
  @override
  Future<EsgMetric?> getMetricById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final metrics = await getMetrics();
    return metrics.firstWhere((m) => m.id == id, orElse: () => metrics.first);
  }

  /// Create mock metric
  @override
  Future<EsgMetric> createMetric(EsgMetric metric) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return metric;
  }

  /// Get mock company profiles
  @override
  Future<List<CompanyProfile>> getCompanies() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      CompanyProfile(
        id: '1',
        name: 'Green Tech Solutions',
        industry: 'Technology',
        esgScore: 87.5,
        description: 'Leading provider of sustainable cloud infrastructure',
      ),
      CompanyProfile(
        id: '2',
        name: 'EcoManufacturing Inc',
        industry: 'Manufacturing',
        esgScore: 72.3,
        description: 'Renewable energy powered production facilities',
      ),
      CompanyProfile(
        id: '3',
        name: 'Sustainable Finance Corp',
        industry: 'Financial Services',
        esgScore: 91.2,
        description: 'ESG-focused investment banking',
      ),
    ];
  }

  /// Get mock company by ID
  @override
  Future<CompanyProfile?> getCompanyProfile(String companyId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final companies = await getCompanies();
    return companies.firstWhere(
      (c) => c.id == companyId,
      orElse: () => companies.first,
    );
  }
}
