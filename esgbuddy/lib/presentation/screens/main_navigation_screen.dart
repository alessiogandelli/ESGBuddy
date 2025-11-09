import 'package:esgbuddy/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:esgbuddy/presentation/screens/stakeholder/stakeholder_screen_refactored.dart';
import 'package:esgbuddy/presentation/screens/improve/improve_screen.dart';
import 'package:esgbuddy/presentation/screens/about/about_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_top_nav_bar.dart';
import '../../data/esg_repository.dart';
import '../../models/company_esg_data.dart';

class MainNavigationScreen extends StatefulWidget {
  final EsgRepository repository;

  const MainNavigationScreen({
    super.key,
    required this.repository,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  List<CompanyESGData> _companies = [];
  CompanyESGData? _selectedCompany;
  bool _isLoading = true;
  String? _error;
  VoidCallback? _downloadCallback;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  Future<void> _loadCompanies() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final companies = await widget.repository.getCompanies();
      setState(() {
        _companies = companies;
        _selectedCompany = companies.isNotEmpty ? companies.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load companies: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Mock Data Banner (shows when using fallback data)
          if (!_isLoading && widget.repository.isUsingMockData)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Backend unavailable - Using demo data',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.repository.resetBackendStatus();
                      _loadCompanies();
                    },
                    child: Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Top Navigation Bar
          CustomTopNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            onDownload: _downloadCallback,
            onAbout: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
          
          // Main content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Colors.red.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadCompanies,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _selectedCompany == null
                        ? const Center(
                            child: Text('No companies available'),
                          )
                        : IndexedStack(
                            index: _currentIndex,
                            children: [
                              // Dashboard
                              DashboardScreen(
                                company: _selectedCompany!,
                                companies: _companies,
                                onCompanyChanged: (newCompany) {
                                  setState(() {
                                    _selectedCompany = newCompany;
                                  });
                                },
                              ),
                              
                              // Stakeholder
                              StakeholderScreen(
                                company: _selectedCompany!,
                                companies: _companies,
                                onCompanyChanged: (newCompany) {
                                  setState(() {
                                    _selectedCompany = newCompany;
                                  });
                                },
                              ),
                              
                              // Improve
                              ImproveScreen(
                                company: _selectedCompany!,
                                companies: _companies,
                                onCompanyChanged: (newCompany) {
                                  setState(() {
                                    _selectedCompany = newCompany;
                                  });
                                },
                                onDownloadCallbackReady: (callback) {
                                  setState(() {
                                    _downloadCallback = callback;
                                  });
                                },
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}
