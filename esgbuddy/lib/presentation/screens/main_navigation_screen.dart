import 'package:esgbuddy/presentation/screens/dashboard/dashboard_screen.dart';
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
          // Top Navigation Bar
          CustomTopNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
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
                              
                              // Stakeholder placeholder
                              const _PlaceholderScreen(
                                title: 'Stakeholder',
                                icon: Icons.groups_rounded,
                              ),
                              
                              // Dipendente (Employee) placeholder
                              const _PlaceholderScreen(
                                title: 'Dipendente',
                                icon: Icons.person_rounded,
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
