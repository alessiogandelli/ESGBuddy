import '../models/company_esg_data.dart';
import 'i_esg_repository.dart';

/// Mock repository for testing without backend
class MockEsgRepository implements IEsgRepository {
  @override
  Future<List<CompanyESGData>> getCompanies() async {
    await Future.delayed(const Duration(seconds: 1));
    // Return empty list - real data comes from backend
    return [];
  }

  @override
  Future<CompanyESGData?> getCompanyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<CompanyESGData?> getCompanyByCode(String companyCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return null;
  }

  @override
  Future<ESGSummaryStats> getSummaryStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return ESGSummaryStats(
      totalCompanies: 0,
      averageOverallScore: 0,
      companiesWithAssurance: 0,
      averageCompleteness: 0,
    );
  }
}
