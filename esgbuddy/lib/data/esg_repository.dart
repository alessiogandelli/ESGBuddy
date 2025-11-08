import '../models/company_esg_data.dart';
import 'api_service.dart';
import 'i_esg_repository.dart';

/// Repository for ESG-related data
/// Acts as an abstraction layer between the data source and the presentation layer
class EsgRepository implements IEsgRepository {
  final ApiService apiService;

  EsgRepository({required this.apiService});

  /// Fetch all companies with their ESG data
  @override
  Future<List<CompanyESGData>> getCompanies() async {
    try {
      final data = await apiService.get('/companies');

      if (data is List) {
        return data.map((json) => CompanyESGData.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch companies: $e');
    }
  }

  /// Fetch a single company by MongoDB ID
  @override
  Future<CompanyESGData?> getCompanyById(String id) async {
    try {
      final data = await apiService.get('/companies/$id');
      return CompanyESGData.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch company: $e');
    }
  }

  /// Fetch a single company by company code (e.g., IT-DEMOCO-2024)
  @override
  Future<CompanyESGData?> getCompanyByCode(String companyCode) async {
    try {
      final data = await apiService.get('/companies/by-code/$companyCode');
      
      if (data == null) {
        return null;
      }
      
      return CompanyESGData.fromJson(data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      print('Error fetching company by code: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to fetch company by code: $e');
    }
  }

  /// Fetch summary statistics
  @override
  Future<ESGSummaryStats> getSummaryStats() async {
    try {
      final data = await apiService.get('/stats/summary');
      return ESGSummaryStats.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch summary stats: $e');
    }
  }
}
