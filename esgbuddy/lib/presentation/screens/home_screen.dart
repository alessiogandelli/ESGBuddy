import 'package:flutter/material.dart';
import '../../data/i_esg_repository.dart';
import '../../models/company_esg_data.dart';

/// Home screen that loads and displays the main company dashboard
class HomeScreen extends StatefulWidget {
  final IEsgRepository repository;
  final String? companyCode;

  const HomeScreen({
    super.key,
    required this.repository,
    this.companyCode = 'IT-DEMOCO-2024',
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<CompanyESGData?> _companyFuture;
  late Future<ESGSummaryStats> _statsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _companyFuture = widget.repository.getCompanyByCode(
      widget.companyCode ?? 'IT-DEMOCO-2024',
    );
    _statsFuture = widget.repository.getSummaryStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESG Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/methodology');
            },
            tooltip: 'View Methodology',
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/companies');
            },
            tooltip: 'View All Companies',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _loadData();
          });
        },
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([_companyFuture, _statsFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return _buildErrorView(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data![0] == null) {
              return _buildErrorView('Company not found');
            }

            final company = snapshot.data![0] as CompanyESGData;
            final stats = snapshot.data![1] as ESGSummaryStats;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Header
                  _buildCompanyHeader(context, company),
                  const SizedBox(height: 24),

                  // Industry Comparison Banner
                  _buildIndustryComparison(context, company, stats),
                  const SizedBox(height: 24),

                  // Main Dashboard Content
                  DashboardContent(company: company, stats: stats),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error Loading Dashboard',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _loadData();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(BuildContext context, CompanyESGData company) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company.basicInfo.tradeName,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        company.basicInfo.legalName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'FY ${company.fiscalYear}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  Icons.business,
                  company.basicInfo.industry,
                  context,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  Icons.location_on,
                  company.basicInfo.country,
                  context,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndustryComparison(
    BuildContext context,
    CompanyESGData company,
    ESGSummaryStats stats,
  ) {
    final diff = company.overallScore - stats.averageOverallScore;
    final isAboveAverage = diff > 0;

    return Card(
      color: isAboveAverage ? Colors.green[50] : Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              isAboveAverage ? Icons.trending_up : Icons.trending_down,
              color: isAboveAverage ? Colors.green[700] : Colors.orange[700],
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Industry Comparison',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} points ${isAboveAverage ? 'above' : 'below'} industry average (${stats.averageOverallScore.toStringAsFixed(1)})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashboard content widget - extracted for reuse
class DashboardContent extends StatelessWidget {
  final CompanyESGData company;
  final ESGSummaryStats stats;

  const DashboardContent({
    super.key,
    required this.company,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Score Card
        _buildOverallScoreCard(context),
        const SizedBox(height: 24),

        // Topic Scores Section
        _buildTopicScoresSection(context),
        const SizedBox(height: 24),

        // SDG Scores Section
        _buildSdgScoresSection(context),
        const SizedBox(height: 24),

        // Report Quality
        _buildReportQuality(context),
      ],
    );
  }

  Widget _buildOverallScoreCard(BuildContext context) {
    final score = company.overallScore;
    final color = _getScoreColor(score);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Overall ESG Score',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.1),
                border: Border.all(color: color, width: 8),
              ),
              child: Center(
                child: Text(
                  score.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getScoreLabel(score),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicScoresSection(BuildContext context) {
    // Group topics by category
    final envTopics = company.topicScores
        .where((t) => ['GRI 302', 'GRI 305', 'GRI 303', 'GRI 306'].contains(t.topicCode))
        .toList();
    final socialTopics = company.topicScores
        .where((t) => ['GRI 403', 'GRI 404', 'GRI 405'].contains(t.topicCode))
        .toList();
    final govTopics = company.topicScores
        .where((t) => ['GRI 205', 'GRI 418/419', 'GRI 2', 'GRI 308/414'].contains(t.topicCode))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESG Performance by Category',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        
        _buildCategoryCard(context, 'Environmental', envTopics, Colors.green),
        const SizedBox(height: 12),
        _buildCategoryCard(context, 'Social', socialTopics, Colors.blue),
        const SizedBox(height: 12),
        _buildCategoryCard(context, 'Governance', govTopics, Colors.purple),
      ],
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String category,
    List<dynamic> topics,
    Color categoryColor,
  ) {
    final avgScore = topics.isEmpty
        ? 0.0
        : topics.map((t) => t.score).reduce((a, b) => a + b) / topics.length;

    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(
            _getCategoryIcon(category),
            color: categoryColor,
          ),
          title: Text(
            category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: LinearProgressIndicator(
            value: avgScore / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              avgScore.toStringAsFixed(1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: categoryColor,
              ),
            ),
          ),
          children: topics.map((topic) => _buildTopicTile(context, topic)).toList(),
        ),
      ),
    );
  }

  Widget _buildTopicTile(BuildContext context, dynamic topic) {
    final color = _getScoreColor(topic.score);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      title: Text(topic.topicCode),
      subtitle: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: topic.score / 100,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ),
      trailing: Text(
        topic.score.toStringAsFixed(1),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Environmental':
        return Icons.nature;
      case 'Social':
        return Icons.people;
      case 'Governance':
        return Icons.gavel;
      default:
        return Icons.category;
    }
  }

  Widget _buildSdgScoresSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'UN SDG Alignment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: company.sdgScores.map((sdg) {
                return _buildSdgBadge(context, sdg);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSdgBadge(BuildContext context, dynamic sdg) {
    final color = _getScoreColor(sdg.score);

    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text(
            'SDG ${sdg.sdg}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            sdg.score.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportQuality(BuildContext context) {
    final qa = company.report.qa;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report Quality',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _buildQualityMetric(
              context,
              'Completeness',
              '${qa.completenessPct.toStringAsFixed(1)}%',
              Icons.check_circle_outline,
            ),
            _buildQualityMetric(
              context,
              'External Assurance',
              qa.hasExternalAssurance ? 'Yes' : 'No',
              Icons.verified_outlined,
            ),
            _buildQualityMetric(
              context,
              'Framework',
              qa.statementOfUse,
              Icons.article_outlined,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }
}
