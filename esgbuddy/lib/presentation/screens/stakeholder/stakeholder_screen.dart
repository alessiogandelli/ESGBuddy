import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/company_esg_data.dart';
import '../../../models/computed_report.dart';

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
  int? _selectedSdg;
  List<int> _availableSdgs = [];

  @override
  void initState() {
    super.initState();
    _updateAvailableSdgs();
  }

  @override
  void didUpdateWidget(StakeholderScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.company.basicInfo.legalName != widget.company.basicInfo.legalName) {
      _updateAvailableSdgs();
      _selectedSdg = null;
    }
  }

  void _updateAvailableSdgs() {
    final sdgs = <int>{};
    for (final company in widget.companies) {
      if (company.basicInfo.legalName == widget.company.basicInfo.legalName) {
        for (final sdgScore in company.report.sdgScores) {
          sdgs.add(sdgScore.sdg);
        }
      }
    }
    setState(() {
      _availableSdgs = sdgs.toList()..sort();
    });
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
            constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildCompanySelector(context),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Select Your SDG of Interest', Icons.flag_outlined),
                const SizedBox(height: 12),
                _buildSdgSelector(context),
                const SizedBox(height: 32),
                if (_selectedSdg != null) ...[
                  _buildSdgRelatedMetrics(context),
                  const SizedBox(height: 32),
                ],
                _buildSectionTitle(context, 'Financial Performance', Icons.attach_money),
                const SizedBox(height: 12),
                _buildFinancialMetricsSection(context),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Environmental Metrics', Icons.eco),
                const SizedBox(height: 12),
                _buildEnvironmentalMetrics(context),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Social Metrics', Icons.people),
                const SizedBox(height: 12),
                _buildSocialMetrics(context),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Governance Metrics', Icons.gavel),
                const SizedBox(height: 12),
                _buildGovernanceMetrics(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.9),
            Theme.of(context).primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stakeholder Analytics',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Detailed metrics, trends, and industry benchmarks',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanySelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.business, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: widget.company.companyId,
                icon: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                items: widget.companies
                    .map((c) => c.companyId)
                    .toSet()
                    .map((companyId) {
                  final company = widget.companies.firstWhere((c) => c.companyId == companyId);
                  return DropdownMenuItem<String>(
                    value: companyId,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          company.basicInfo.tradeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${company.basicInfo.industry} • ${company.basicInfo.sector}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newCompanyId) {
                  if (newCompanyId != null) {
                    final newCompany = widget.companies.firstWhere(
                      (c) => c.companyId == newCompanyId,
                    );
                    widget.onCompanyChanged(newCompany);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSdgSelector(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.track_changes, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Click an SDG to see related metrics and trends',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableSdgs.map((sdg) {
              final isSelected = _selectedSdg == sdg;
              final sdgScore = widget.company.report.sdgScores
                  .firstWhere((s) => s.sdg == sdg, orElse: () => SdgScore(sdg: sdg, score: 0, materialTopicsContributing: []));
              
              return _buildSdgChip(context, sdg, sdgScore.score, isSelected);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSdgChip(BuildContext context, int sdg, double score, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSdg = isSelected ? null : sdg;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag,
              size: 20,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'SDG $sdg',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  _getSdgName(sdg),
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected ? Colors.white.withValues(alpha: 0.9) : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdgRelatedMetrics(BuildContext context) {
    final companyHistory = _getCompanyHistory();
    final sdgTopics = _getSdgRelatedTopics(_selectedSdg!);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.flag,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SDG $_selectedSdg: ${_getSdgName(_selectedSdg!)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Metrics related to this goal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          ...sdgTopics.expand((topic) => _buildTopicMetrics(context, topic, companyHistory)),
        ],
      ),
    );
  }

  List<String> _getSdgRelatedTopics(int sdg) {
    final topics = <String>{};
    switch (sdg) {
      case 7:
      case 13:
        topics.addAll(['energy_climate']);
        break;
      case 6:
      case 14:
      case 15:
        topics.addAll(['water_waste', 'biodiversity']);
        break;
      case 5:
      case 8:
      case 10:
        topics.addAll(['employee_wellbeing', 'diversity_inclusion']);
        break;
      case 3:
        topics.addAll(['health_safety', 'employee_wellbeing']);
        break;
      case 16:
        topics.addAll(['ethics_compliance', 'anti_corruption']);
        break;
      default:
        topics.addAll(['energy_climate', 'employee_wellbeing', 'ethics_compliance']);
    }
    return topics.toList();
  }

  List<Widget> _buildTopicMetrics(BuildContext context, String topicCode, List<CompanyESGData> history) {
    final widgets = <Widget>[];
    
    if (topicCode == 'energy_climate') {
      final topic = widget.company.topics.environmental.energyClimate;
      widgets.addAll([
        _buildMetricCard(
          'Total Emissions (tCO2e)',
          _formatNumber(topic.metrics.scope1Tco2e + topic.metrics.scope2MarketTco2e + topic.metrics.scope3SelectedTco2e),
          Icons.cloud_outlined,
          _buildEmissionsChart(history),
        ),
        const SizedBox(height: 16),
        _buildMetricCard(
          'Renewable Energy',
          '${topic.metrics.renewableEnergyPct.toStringAsFixed(1)}%',
          Icons.wb_sunny_outlined,
          _buildRenewableEnergyChart(history),
        ),
        const SizedBox(height: 16),
      ]);
    }

    if (topicCode == 'employee_wellbeing') {
      final topic = widget.company.topics.social.workforce;
      widgets.addAll([
        _buildMetricCard(
          'Total Employees',
          _formatNumber(topic.metrics.totalHeadcount.toDouble()),
          Icons.people_outline,
          _buildEmployeeChart(history),
        ),
        const SizedBox(height: 16),
      ]);
    }

    if (topicCode == 'diversity_inclusion') {
      final workforce = widget.company.topics.social.workforce;
      final totalEmployees = workforce.metrics.totalHeadcount;
      final womenCount = workforce.metrics.employeesByGender['Female'] ?? 0;
      final womenPct = totalEmployees > 0 ? (womenCount / totalEmployees * 100) : 0;
      widgets.addAll([
        _buildMetricCard(
          'Women in Workforce',
          '${womenPct.toStringAsFixed(1)}%',
          Icons.woman_outlined,
          _buildDiversityChart(history),
        ),
        const SizedBox(height: 16),
      ]);
    }

    return widgets;
  }

  Widget _buildFinancialMetricsSection(BuildContext context) {
    final financial = widget.company.basicInfo.financialMetrics;
    final companyHistory = _getCompanyHistory();

    if (financial == null) {
      return _buildNoDataCard('No financial data available');
    }

    final industryBenchmark = _getIndustryBenchmark(widget.company.basicInfo.industry);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFinancialCard(
                'Annual Revenue',
                '${financial.currency} ${_formatNumber(financial.annualRevenue)}',
                Icons.trending_up,
                Colors.blue,
                industryBenchmark['revenue'],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFinancialCard(
                'EBITDA',
                '${financial.currency} ${_formatNumber(financial.ebitda)}',
                Icons.account_balance,
                Colors.green,
                industryBenchmark['ebitda'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildFinancialCard(
                'Total Assets',
                '${financial.currency} ${_formatNumber(financial.totalAssets)}',
                Icons.business_center,
                Colors.purple,
                null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildFinancialCard(
                'Sustainability Investment',
                '${financial.currency} ${_formatNumber(financial.sustainabilityInvestment)}',
                Icons.eco,
                Theme.of(context).primaryColor,
                industryBenchmark['sustainability'],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildMetricCard(
          'Revenue Trend Over Years',
          '',
          Icons.show_chart,
          _buildRevenueChart(companyHistory),
        ),
        const SizedBox(height: 16),
        _buildMetricCard(
          'R&D vs Sustainability Investment',
          '',
          Icons.compare_arrows,
          _buildInvestmentComparisonChart(companyHistory),
        ),
      ],
    );
  }

  Widget _buildEnvironmentalMetrics(BuildContext context) {
    final environmental = widget.company.topics.environmental;
    final companyHistory = _getCompanyHistory();

    final widgets = <Widget>[];

    final metrics = environmental.energyClimate.metrics;
    widgets.addAll([
      _buildMetricCard(
        'Total Energy Consumption',
        '${_formatNumber(metrics.electricityConsumedKwh)} kWh',
        Icons.bolt,
        _buildEnergyConsumptionChart(companyHistory),
      ),
      const SizedBox(height: 16),
      _buildMetricCard(
        'GHG Emissions Breakdown',
        'Scope 1+2+3',
        Icons.cloud,
        _buildEmissionsBreakdownChart(companyHistory),
      ),
      const SizedBox(height: 16),
    ]);
  
    final waterMetrics = environmental.water.metrics;
    widgets.addAll([
      _buildMetricCard(
        'Water Withdrawal',
        '${_formatNumber(waterMetrics.waterWithdrawalM3)} m³',
        Icons.water_drop,
        _buildWaterChart(companyHistory),
      ),
      const SizedBox(height: 16),
    ]);

    return Column(children: widgets.isEmpty ? [_buildNoDataCard('No environmental metrics')] : widgets);
  }

  Widget _buildSocialMetrics(BuildContext context) {
    final social = widget.company.topics.social;
    final companyHistory = _getCompanyHistory();

    final widgets = <Widget>[];

    final workforceMetrics = social.workforce.metrics;
    final totalEmployees = workforceMetrics.totalHeadcount;
    final turnoverRate = totalEmployees > 0 
        ? ((workforceMetrics.departures / totalEmployees) * 100) 
        : 0.0;
    widgets.addAll([
      Row(
        children: [
          Expanded(
            child: _buildMetricCardSimple(
              'Total Employees',
              _formatNumber(totalEmployees.toDouble()),
              Icons.people,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMetricCardSimple(
              'Employee Turnover',
              '${turnoverRate.toStringAsFixed(1)}%',
              Icons.transfer_within_a_station,
              Colors.orange,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ]);

    final womenCount = workforceMetrics.employeesByGender['Female'] ?? 0;
    final womenPct = totalEmployees > 0 ? (womenCount / totalEmployees * 100) : 0;
    final womenLeadershipPct = totalEmployees > 0 
        ? (workforceMetrics.womenInManagement / totalEmployees * 100) 
        : 0;
    widgets.addAll([
      Row(
        children: [
          Expanded(
            child: _buildMetricCardSimple(
              'Women in Workforce',
              '${womenPct.toStringAsFixed(1)}%',
              Icons.woman,
              Colors.pink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMetricCardSimple(
              'Women in Leadership',
              '${womenLeadershipPct.toStringAsFixed(1)}%',
              Icons.business_center,
              Colors.purple,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ]);

    final metrics = social.healthSafety.metrics;
    widgets.addAll([
      _buildMetricCard(
        'Lost Time Injury Rate',
        metrics.ltir.toStringAsFixed(2),
        Icons.healing,
        _buildSafetyChart(companyHistory),
      ),
      const SizedBox(height: 16),
    ]);
  
    return Column(children: widgets.isEmpty ? [_buildNoDataCard('No social metrics')] : widgets);
  }

  Widget _buildGovernanceMetrics(BuildContext context) {
    final governance = widget.company.topics.governance;

    final widgets = <Widget>[];

    final metrics = governance.boardGovernance.metrics;
    widgets.addAll([
      Row(
        children: [
          Expanded(
            child: _buildMetricCardSimple(
              'Board Size',
              metrics.boardSize.toString(),
              Icons.groups,
              Colors.indigo,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMetricCardSimple(
              'Independent Directors',
              '${metrics.independentDirectorsPct.toStringAsFixed(1)}%',
              Icons.verified_user,
              Colors.teal,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _buildMetricCardSimple(
              'Women on Board',
              '${metrics.boardGenderDiversityWomenPct.toStringAsFixed(1)}%',
              Icons.woman,
              Colors.pink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMetricCardSimple(
              'Avg. Board Attendance',
              '${metrics.avgBoardAttendancePct.toStringAsFixed(1)}%',
              Icons.schedule,
              Colors.blueGrey,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
    ]);

    return Column(children: widgets.isEmpty ? [_buildNoDataCard('No governance metrics')] : widgets);
  }

  Widget _buildFinancialCard(String label, String value, IconData icon, Color color, double? benchmark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (benchmark != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.business,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Industry: ${_formatNumber(benchmark)}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String subtitle, IconData icon, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: chart,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCardSimple(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(String message) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final revenue = history[i].basicInfo.financialMetrics?.annualRevenue ?? 0;
      spots.add(FlSpot(i.toDouble(), revenue / 1000000));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '€${value.toInt()}M',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionsChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final climate = history[i].topics.environmental.energyClimate.metrics;
      final total = climate.scope1Tco2e + climate.scope2MarketTco2e + climate.scope3SelectedTco2e;
      spots.add(FlSpot(i.toDouble(), total));
        }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No emissions data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.red,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewableEnergyChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final climate = history[i].topics.environmental.energyClimate.metrics;
      spots.add(FlSpot(i.toDouble(), climate.renewableEnergyPct));
        }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No renewable energy data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.green.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final employees = history[i].topics.social.workforce.metrics.totalHeadcount;
      spots.add(FlSpot(i.toDouble(), employees.toDouble()));
    }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No employee data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildDiversityChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final workforce = history[i].topics.social.workforce.metrics;
      final womenCount = workforce.employeesByGender['Female'] ?? 0;
      final totalEmployees = workforce.totalHeadcount;
      if (totalEmployees > 0) {
        final womenPct = (womenCount / totalEmployees) * 100;
        spots.add(FlSpot(i.toDouble(), womenPct));
      }
    }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No diversity data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}%',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.pink,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentComparisonChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final rdSpots = <FlSpot>[];
    final sustainSpots = <FlSpot>[];
    
    for (var i = 0; i < history.length; i++) {
      final financial = history[i].basicInfo.financialMetrics;
      if (financial != null) {
        rdSpots.add(FlSpot(i.toDouble(), financial.rdInvestment / 1000000));
        sustainSpots.add(FlSpot(i.toDouble(), financial.sustainabilityInvestment / 1000000));
      }
    }

    if (rdSpots.isEmpty) {
      return _buildNoDataMessage('No investment data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '€${value.toInt()}M',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: rdSpots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
          LineChartBarData(
            spots: sustainSpots,
            isCurved: true,
            color: Colors.green,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildEnergyConsumptionChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final energy = history[i].topics.environmental.energyClimate.metrics.electricityConsumedKwh;
      spots.add(FlSpot(i.toDouble(), energy / 1000000));
        }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No energy data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}M kWh',
                  style: const TextStyle(fontSize: 9),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.amber,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildEmissionsBreakdownChart(List<CompanyESGData> history) {
    final latestData = widget.company.topics.environmental.energyClimate.metrics;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (latestData.scope1Tco2e + latestData.scope2MarketTco2e + latestData.scope3SelectedTco2e) * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Scope 1', style: TextStyle(fontSize: 11));
                  case 1:
                    return const Text('Scope 2', style: TextStyle(fontSize: 11));
                  case 2:
                    return const Text('Scope 3', style: TextStyle(fontSize: 11));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [
            BarChartRodData(toY: latestData.scope1Tco2e, color: Colors.red.shade700, width: 40),
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(toY: latestData.scope2MarketTco2e, color: Colors.orange.shade700, width: 40),
          ]),
          BarChartGroupData(x: 2, barRods: [
            BarChartRodData(toY: latestData.scope3SelectedTco2e, color: Colors.yellow.shade700, width: 40),
          ]),
        ],
      ),
    );
  }

  Widget _buildWaterChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final water = history[i].topics.environmental.water.metrics.waterWithdrawalM3;
      spots.add(FlSpot(i.toDouble(), water));
    }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No water data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()} m³',
                  style: const TextStyle(fontSize: 9),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.cyan,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyChart(List<CompanyESGData> history) {
    if (history.length < 2) {
      return _buildNoDataMessage('Need multiple years of data');
    }

    final spots = <FlSpot>[];
    for (var i = 0; i < history.length; i++) {
      final ltir = history[i].topics.social.healthSafety.metrics.ltir;
      spots.add(FlSpot(i.toDouble(), ltir));
    }

    if (spots.isEmpty) {
      return _buildNoDataMessage('No safety data');
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < history.length) {
                  return Text(
                    'FY${history[value.toInt()].fiscalYear}',
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.orange,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataMessage(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 13,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Map<String, double> _getIndustryBenchmark(String industry) {
    return {
      'revenue': 150000000.0,
      'ebitda': 27000000.0,
      'sustainability': 2500000.0,
    };
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  String _getSdgName(int sdg) {
    const sdgNames = {
      1: 'No Poverty',
      2: 'Zero Hunger',
      3: 'Good Health',
      4: 'Quality Education',
      5: 'Gender Equality',
      6: 'Clean Water',
      7: 'Clean Energy',
      8: 'Decent Work',
      9: 'Innovation',
      10: 'Reduced Inequalities',
      11: 'Sustainable Cities',
      12: 'Responsible Consumption',
      13: 'Climate Action',
      14: 'Life Below Water',
      15: 'Life on Land',
      16: 'Peace & Justice',
      17: 'Partnerships',
    };
    return sdgNames[sdg] ?? 'Unknown SDG';
  }
}
