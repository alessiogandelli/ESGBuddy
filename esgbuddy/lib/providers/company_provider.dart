import 'package:flutter/foundation.dart';
import '../models/company_esg_data.dart';
import '../data/i_esg_repository.dart';

/// Global provider for managing company data throughout the app
/// Fetches and holds all companies and tracks the currently selected one
class CompanyProvider extends ChangeNotifier {
  final IEsgRepository repository;
  
  List<CompanyESGData> _companies = [];
  CompanyESGData? _selectedCompany;
  bool _isLoading = false;
  String? _error;

  CompanyProvider({required this.repository});

  List<CompanyESGData> get companies => _companies;
  CompanyESGData? get company => _selectedCompany;
  CompanyESGData? get selectedCompany => _selectedCompany;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _selectedCompany != null;

  /// Fetch all companies from the repository
  Future<void> loadCompanies() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _companies = await repository.getCompanies();
      if (_companies.isNotEmpty) {
        _selectedCompany = _companies.first;
        _error = null;
      } else {
        _error = 'No companies found';
      }
    } catch (e) {
      _error = 'Failed to load companies: $e';
      _companies = [];
      _selectedCompany = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select a specific company
  void selectCompany(CompanyESGData company) {
    _selectedCompany = company;
    notifyListeners();
  }

  /// Select company by ID
  void selectCompanyById(String companyId) {
    final company = _companies.firstWhere(
      (c) => c.companyId == companyId,
      orElse: () => _companies.first,
    );
    selectCompany(company);
  }

  /// Refresh company data
  Future<void> refresh() async {
    await loadCompanies();
  }
}
