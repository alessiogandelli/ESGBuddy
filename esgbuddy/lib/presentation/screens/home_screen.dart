import 'package:flutter/material.dart';
import '../../providers/company_provider.dart';
import 'dashboard/dashboard_screen.dart';

/// Home Screen - displays the dashboard of the first company
/// This is the main entry point of the app
class HomeScreen extends StatefulWidget {
  final CompanyProvider companyProvider;

  const HomeScreen({super.key, required this.companyProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load companies when the app starts
    _loadCompany();
  }

  Future<void> _loadCompany() async {
    await widget.companyProvider.loadCompanies();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.companyProvider,
      builder: (context, child) {
        if (widget.companyProvider.isLoading) {
          return _buildLoadingState(context);
        }

        if (widget.companyProvider.error != null) {
          return _buildErrorState(context);
        }

        final company = widget.companyProvider.company;
        if (company != null) {
          return DashboardScreen(company: company);
        }

        return _buildNoDataState();
      },
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading ESG data...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              widget.companyProvider.error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadCompany,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Scaffold(
      appBar: AppBar(title: const Text('ESG Buddy')),
      body: const Center(
        child: Text('No company data available'),
      ),
    );
  }
}
