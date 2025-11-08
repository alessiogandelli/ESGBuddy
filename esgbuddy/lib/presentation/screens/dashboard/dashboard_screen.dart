import 'package:esgbuddy/presentation/screens/dashboard/widgets/dashboard_body.dart';
import 'package:esgbuddy/presentation/screens/dashboard/widgets/dashboard_hero.dart';
import 'package:esgbuddy/presentation/widgets/company_selector.dart';
import 'package:flutter/material.dart';
import '../../../models/company_esg_data.dart';

enum FilterFramework { gri, sdg }

class DashboardScreen extends StatefulWidget {
  final CompanyESGData company;
  final List<CompanyESGData> companies;
  final Function(CompanyESGData) onCompanyChanged;

  const DashboardScreen({
    super.key, 
    required this.company,
    required this.companies,
    required this.onCompanyChanged,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  FilterFramework _selectedFramework = FilterFramework.gri;
  String? _selectedCategory; // Environmental, Social, or Governance

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Company Selector
                CompanySelector(
                  selectedCompany: widget.company,
                  companies: widget.companies,
                  onCompanyChanged: widget.onCompanyChanged,
                ),
                const SizedBox(height: 16),
                
                // Framework Pill Selector
                _buildFrameworkSelector(context),
                const SizedBox(height: 16),
                
                DashboardHero(
                  company: widget.company,
                  selectedFramework: _selectedFramework,
                  selectedCategory: _selectedCategory,
                  onCategoryTap: (category) {
                    setState(() {
                      _selectedCategory = _selectedCategory == category ? null : category;
                    });
                  },
                ),
                const SizedBox(height: 24),
                DashboardBody(
                  company: widget.company,
                  selectedFramework: _selectedFramework,
                  selectedCategory: _selectedCategory,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrameworkSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildFrameworkPill(
              context,
              FilterFramework.gri,
              'GRI Framework',
              Icons.eco_outlined,
            ),
          ),
          Expanded(
            child: _buildFrameworkPill(
              context,
              FilterFramework.sdg,
              'SDG Framework',
              Icons.public,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameworkPill(
    BuildContext context,
    FilterFramework framework,
    String label,
    IconData icon,
  ) {
    final isSelected = _selectedFramework == framework;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFramework = framework;
          _selectedCategory = null; // Reset category filter when changing framework
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
