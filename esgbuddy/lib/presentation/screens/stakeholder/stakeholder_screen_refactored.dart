import 'package:flutter/material.dart';
import '../../../models/company_esg_data.dart';
import '../../widgets/company_selector.dart';
import 'widgets/common_widgets.dart';
import 'widgets/financial_metrics.dart';
import 'widgets/environmental_metrics.dart';
import 'widgets/social_metrics.dart';
import 'widgets/governance_metrics.dart';

enum ESGCategory { financial, environmental, social, governance }

class StakeholderScreen extends StatefulWidget {
  final CompanyESGData company;
  final List<CompanyESGData> companies;
  final Function(CompanyESGData) onCompanyChanged;

  const StakeholderScreen({
    super.key,
    required this.company,
    required this.companies,
    required this.onCompanyChanged,
  });

  @override
  State<StakeholderScreen> createState() => _StakeholderScreenState();
}

class _StakeholderScreenState extends State<StakeholderScreen> {
  ESGCategory _selectedCategory = ESGCategory.financial;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(StakeholderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.company.basicInfo.legalName != widget.company.basicInfo.legalName) {
      setState(() => _selectedCategory = ESGCategory.financial);
    }
  }

  List<CompanyESGData> _getCompanyHistory() {
    final filteredCompanies = widget.companies
        .where((c) => c.basicInfo.legalName == widget.company.basicInfo.legalName)
        .toList()
      ..sort((a, b) => a.fiscalYear.compareTo(b.fiscalYear));
    
    // Remove duplicates by fiscal year, keeping the most recent entry (by createdAt)
    final Map<int, CompanyESGData> uniqueByYear = {};
    for (final company in filteredCompanies) {
      final existing = uniqueByYear[company.fiscalYear];
      if (existing == null || company.createdAt.isAfter(existing.createdAt)) {
        uniqueByYear[company.fiscalYear] = company;
      }
    }
    
    return uniqueByYear.values.toList()
      ..sort((a, b) => a.fiscalYear.compareTo(b.fiscalYear));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 800 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                
               

                // Company Selector
                CompanySelector(
                  selectedCompany: widget.company,
                  companies: widget.companies,
                  onCompanyChanged: widget.onCompanyChanged,
                ),
                const SizedBox(height: 24),

                // ESG Category Tab Bar
                _buildCategoryTabBar(),
                const SizedBox(height: 32),

                // Display content based on selected category
                _buildCategoryContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabBar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTabButton(
            'Financial',
            Icons.attach_money,
            ESGCategory.financial,
          ),
          _buildTabButton(
            'Environmental',
            Icons.eco,
            ESGCategory.environmental,
          ),
          _buildTabButton(
            'Social',
            Icons.people,
            ESGCategory.social,
          ),
          _buildTabButton(
            'Governance',
            Icons.gavel,
            ESGCategory.governance,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, IconData icon, ESGCategory category) {
    final isSelected = _selectedCategory == category;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = category),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E88E5) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case ESGCategory.financial:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const SectionTitle(
                title: 'Financial Performance',
                icon: Icons.attach_money,
              ),
            ),
            const SizedBox(height: 12),
            FinancialMetricsWidget(company: widget.company.basicInfo),
          ],
        );

      case ESGCategory.environmental:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const SectionTitle(
                title: 'Environmental Performance',
                icon: Icons.eco,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: EnvironmentalMetricsWidget(
                environmental: widget.company.topics.environmental,
                companyHistory: _getCompanyHistory(),
              ),
            ),
          ],
        );

      case ESGCategory.social:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const SectionTitle(
                title: 'Social Performance',
                icon: Icons.people,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SocialMetricsWidget(
                social: widget.company.topics.social,
              ),
            ),
          ],
        );

      case ESGCategory.governance:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const SectionTitle(
                title: 'Governance Performance',
                icon: Icons.gavel,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GovernanceMetricsWidget(
                governance: widget.company.topics.governance,
              ),
            ),
          ],
        );
    }
  }
}
