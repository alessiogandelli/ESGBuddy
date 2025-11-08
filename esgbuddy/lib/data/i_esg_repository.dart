import '../models/company_esg_data.dart';

/// Base repository interface for ESG data
/// Both real and mock repositories implement this
abstract class IEsgRepository {
  Future<List<CompanyESGData>> getCompanies();
  Future<CompanyESGData?> getCompanyById(String id);
  Future<CompanyESGData?> getCompanyByCode(String companyCode);
  Future<ESGSummaryStats> getSummaryStats();
}
