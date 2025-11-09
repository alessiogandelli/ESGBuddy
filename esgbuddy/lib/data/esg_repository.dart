import '../models/company_esg_data.dart';
import 'api_service.dart';
import 'i_esg_repository.dart';
import 'mock_esg_repository.dart';

/// Repository for ESG-related data
/// Acts as an abstraction layer between the data source and the presentation layer
/// Automatically falls back to mock data when backend is unavailable
class EsgRepository implements IEsgRepository {
  final ApiService apiService;
  final MockEsgRepository _mockRepository = MockEsgRepository();
  bool _useBackend = true;

  EsgRepository({required this.apiService});

  /// Fetch all companies with their ESG data
  @override
  Future<List<CompanyESGData>> getCompanies() async {
    if (!_useBackend) {
      print('Using mock data (backend unavailable)');
      return _mockRepository.getCompanies();
    }

    try {
      final data = await apiService.get('/companies');

      if (data is List) {
        return data.map((json) => CompanyESGData.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Backend error, falling back to mock data: $e');
      _useBackend = false;
      return _mockRepository.getCompanies();
    }
  }

  /// Fetch a single company by MongoDB ID
  @override
  Future<CompanyESGData?> getCompanyById(String id) async {
    if (!_useBackend) {
      print('Using mock data (backend unavailable)');
      return _mockRepository.getCompanyById(id);
    }

    try {
      final data = await apiService.get('/companies/$id');
      return CompanyESGData.fromJson(data);
    } catch (e) {
      print('Backend error, falling back to mock data: $e');
      _useBackend = false;
      return _mockRepository.getCompanyById(id);
    }
  }

  /// Fetch a single company by company code (e.g., IT-DEMOCO-2024)
  @override
  Future<CompanyESGData?> getCompanyByCode(String companyCode) async {
    if (!_useBackend) {
      print('Using mock data (backend unavailable)');
      return _mockRepository.getCompanyByCode(companyCode);
    }

    try {
      final data = await apiService.get('/companies/by-code/$companyCode');
      
      if (data == null) {
        return null;
      }
      
      return CompanyESGData.fromJson(data as Map<String, dynamic>);
    } catch (e, stackTrace) {
      print('Backend error, falling back to mock data: $e');
      print('Stack trace: $stackTrace');
      _useBackend = false;
      return _mockRepository.getCompanyByCode(companyCode);
    }
  }

  /// Fetch summary statistics
  @override
  Future<ESGSummaryStats> getSummaryStats() async {
    if (!_useBackend) {
      print('Using mock data (backend unavailable)');
      return _mockRepository.getSummaryStats();
    }

    try {
      final data = await apiService.get('/stats/summary');
      return ESGSummaryStats.fromJson(data);
    } catch (e) {
      print('Backend error, falling back to mock data: $e');
      _useBackend = false;
      return _mockRepository.getSummaryStats();
    }
  }

  /// Reset backend availability flag (for retrying connection)
  void resetBackendStatus() {
    _useBackend = true;
  }

  /// Check if currently using mock data
  bool get isUsingMockData => !_useBackend;
}

