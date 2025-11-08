import 'package:flutter/material.dart';
import '../../models/company_esg_data.dart';
import '../../models/computed_report.dart';
import '../widgets/circular_score_indicator.dart';
import '../helpers/sdg_helper.dart';
import '../helpers/gri_topic_helper.dart';

class DashboardScreen extends StatelessWidget {
  final CompanyESGData company;

  const DashboardScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(company.companyName),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/methodology');
            },
            tooltip: 'View Methodology',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header with gradient
            _buildCompanyHeader(context),
            
            // Main Content
            Padding(
              padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overall Score Card
                  _buildOverallScoreCard(context, isDesktop),
                  const SizedBox(height: 32),

                  // ESG Breakdown
                  _buildEsgBreakdownSection(context, isDesktop),
                  const SizedBox(height: 32),

                  // Topic Scores Section
                  _buildTopicScoresSection(context, isDesktop),
                  const SizedBox(height: 32),

                  // SDG Scores Section
                  _buildSdgScoresSection(context, isDesktop),
                  const SizedBox(height: 32),

                  // Report Quality
                  _buildReportQuality(context, isDesktop),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              company.basicInfo.legalName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    company.basicInfo.industry,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  company.basicInfo.country,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  'FY ${company.fiscalYear}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context, bool isDesktop) {
    final score = company.overallScore;
    final color = _getScoreColor(score);
    final label = _getScoreLabel(score);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              Colors.white,
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 32.0 : 24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.eco, color: color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall ESG Score',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Comprehensive sustainability performance rating',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CircularScoreIndicator(
                score: score,
                size: isDesktop ? 160 : 140,
                label: label,
              ),
              const SizedBox(height: 16),
              _buildScoreLegend(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreLegend(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildLegendItem(context, 'Excellent', const Color(0xFF4CAF50), '80-100'),
        _buildLegendItem(context, 'Good', const Color(0xFFFF9800), '60-79'),
        _buildLegendItem(context, 'Fair', const Color(0xFFFFC107), '40-59'),
        _buildLegendItem(context, 'Needs Improvement', const Color(0xFFF44336), '0-39'),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color, String range) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($range)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[700],
              ),
        ),
      ],
    );
  }

  Widget _buildEsgBreakdownSection(BuildContext context, bool isDesktop) {
    // Group topics by category
    final environmental = company.topicScores.where((t) => 
      GriTopicHelper.getCategory(t.topicCode) == 'Environmental'
    ).toList();
    final social = company.topicScores.where((t) => 
      GriTopicHelper.getCategory(t.topicCode) == 'Social'
    ).toList();
    final governance = company.topicScores.where((t) => 
      GriTopicHelper.getCategory(t.topicCode) == 'Economic' ||
      GriTopicHelper.getCategory(t.topicCode) == 'Universal'
    ).toList();

    final eScore = environmental.isEmpty ? 0.0 : 
      environmental.map((e) => e.score).reduce((a, b) => a + b) / environmental.length;
    final sScore = social.isEmpty ? 0.0 : 
      social.map((e) => e.score).reduce((a, b) => a + b) / social.length;
    final gScore = governance.isEmpty ? 0.0 : 
      governance.map((e) => e.score).reduce((a, b) => a + b) / governance.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESG Breakdown',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Environmental, Social, and Governance performance pillars',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 16),
        isDesktop
            ? Row(
                children: [
                  Expanded(child: _buildEsgPillarCard(context, 'Environmental', eScore, Icons.forest, const Color(0xFF4CAF50))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildEsgPillarCard(context, 'Social', sScore, Icons.people, const Color(0xFF2196F3))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildEsgPillarCard(context, 'Governance', gScore, Icons.gavel, const Color(0xFF9C27B0))),
                ],
              )
            : Column(
                children: [
                  _buildEsgPillarCard(context, 'Environmental', eScore, Icons.forest, const Color(0xFF4CAF50)),
                  const SizedBox(height: 12),
                  _buildEsgPillarCard(context, 'Social', sScore, Icons.people, const Color(0xFF2196F3)),
                  const SizedBox(height: 12),
                  _buildEsgPillarCard(context, 'Governance', gScore, Icons.gavel, const Color(0xFF9C27B0)),
                ],
              ),
      ],
    );
  }

  Widget _buildEsgPillarCard(BuildContext context, String title, double score, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CircularScoreIndicator(
              score: score,
              size: 100,
              showLabel: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicScoresSection(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics_outlined, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GRI Topic Performance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Detailed scores across Global Reporting Initiative standards',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: company.topicScores.map((topic) {
                return _buildTopicScoreBar(context, topic);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicScoreBar(BuildContext context, TopicScore topic) {
    final color = _getScoreColor(topic.score);
    final topicName = GriTopicHelper.getName(topic.topicCode);
    final topicDesc = GriTopicHelper.getDescription(topic.topicCode);
    final category = GriTopicHelper.getCategory(topic.topicCode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _getCategoryColor(category).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getCategoryColor(category),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topicName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (topicDesc.isNotEmpty)
                      Text(
                        topicDesc,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontSize: 11,
                            ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  topic.score.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: topic.score / 100,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (topic.completeness < 1.0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 14, color: Colors.orange[700]),
                  const SizedBox(width: 4),
                  Text(
                    'Data completeness: ${(topic.completeness * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                          fontSize: 11,
                        ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Environmental':
        return const Color(0xFF4CAF50);
      case 'Social':
        return const Color(0xFF2196F3);
      case 'Economic':
      case 'Universal':
        return const Color(0xFF9C27B0);
      default:
        return Colors.grey;
    }
  }

  Widget _buildSdgScoresSection(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.public, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UN Sustainable Development Goals',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Contribution to the UN\'s 2030 Agenda for Sustainable Development',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        isDesktop
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: company.sdgScores.length,
                itemBuilder: (context, index) {
                  return _buildSdgCard(context, company.sdgScores[index], isDesktop);
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: company.sdgScores.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildSdgCard(context, company.sdgScores[index], isDesktop),
                  );
                },
              ),
      ],
    );
  }

  Widget _buildSdgCard(BuildContext context, SdgScore sdg, bool isDesktop) {
    final sdgInfo = SdgHelper.getInfo(sdg.sdg);
    if (sdgInfo == null) return const SizedBox();

    if (isDesktop) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showSdgDetails(context, sdg, sdgInfo),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularScoreIndicator(
                  score: sdg.score,
                  size: 100,
                  showLabel: false,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: sdgInfo.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'SDG ${sdg.sdg}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sdgInfo.color,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  sdgInfo.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () => _showSdgDetails(context, sdg, sdgInfo),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircularScoreIndicator(
                  score: sdg.score,
                  size: 80,
                  showLabel: false,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: sdgInfo.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(sdgInfo.icon, size: 16, color: sdgInfo.color),
                            const SizedBox(width: 6),
                            Text(
                              'SDG ${sdg.sdg}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: sdgInfo.color,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        sdgInfo.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sdgInfo.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _showSdgDetails(BuildContext context, SdgScore sdg, SdgInfo sdgInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(sdgInfo.icon, color: sdgInfo.color),
            const SizedBox(width: 12),
            Expanded(
              child: Text('SDG ${sdg.sdg}: ${sdgInfo.name}'),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: CircularScoreIndicator(
                  score: sdg.score,
                  size: 120,
                  label: _getScoreLabel(sdg.score),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                sdgInfo.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Contributing Topics:',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              ...sdg.materialTopicsContributing.map((topic) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: sdgInfo.color),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            GriTopicHelper.getName(topic),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportQuality(BuildContext context, bool isDesktop) {
    final qa = company.report.qa;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.verified_outlined, color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Quality & Assurance',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data completeness and verification status',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildQualityMetric(
                  context,
                  'Data Completeness',
                  '${qa.completenessPct.toStringAsFixed(1)}%',
                  Icons.assessment,
                  'Percentage of required disclosures provided',
                  qa.completenessPct,
                ),
                const Divider(height: 32),
                _buildQualityMetric(
                  context,
                  'External Assurance',
                  qa.hasExternalAssurance ? 'Yes' : 'No',
                  Icons.verified,
                  'Independent third-party verification status',
                  qa.hasExternalAssurance ? 100 : 0,
                ),
                const Divider(height: 32),
                _buildQualityMetric(
                  context,
                  'Reporting Framework',
                  qa.statementOfUse,
                  Icons.article,
                  'Standards and frameworks used for reporting',
                  null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQualityMetric(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    String description,
    double? progressValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: progressValue != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              value,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _getScoreColor(progressValue),
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progressValue / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(progressValue),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
            ),
          ],
        ),
      ],
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
