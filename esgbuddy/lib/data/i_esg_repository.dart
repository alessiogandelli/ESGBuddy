import '../models/esg_metric.dart';
import '../models/company_profile.dart';

/// Base repository interface for ESG data
/// Both real and mock repositories implement this
abstract class IEsgRepository {
  Future<List<EsgMetric>> getMetrics();
  Future<EsgMetric?> getMetricById(String id);
  Future<EsgMetric> createMetric(EsgMetric metric);
  Future<CompanyProfile?> getCompanyProfile(String companyId);
  Future<List<CompanyProfile>> getCompanies();
}
