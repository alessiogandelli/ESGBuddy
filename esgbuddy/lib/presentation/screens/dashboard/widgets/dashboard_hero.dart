import 'package:esgbuddy/models/company_esg_data.dart';
import 'package:esgbuddy/models/computed_report.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CategoryData {
  final double score;
  final List<String> griCodes;
  final List<String> sdgs;
  final List<TopicScore> topicScores;

  CategoryData({
    required this.score,
    required this.griCodes,
    required this.sdgs,
    required this.topicScores,
  });
}

class DashboardHero extends StatefulWidget {
  final CompanyESGData company;

  const DashboardHero({
    super.key,
    required this.company,
  });

  @override
  State<DashboardHero> createState() => _DashboardHeroState();
}

class _DashboardHeroState extends State<DashboardHero> {
  String? _expandedCategory;

  // Helper to extract all GRI codes from a category
  List<String> _getGriCodesForCategory(String category) {
    final topics = widget.company.topics;
    List<String> griCodes = [];
    
    switch (category) {
      case 'Environmental':
        griCodes.addAll(topics.environmental.energyClimate.griMapping);
        griCodes.addAll(topics.environmental.water.griMapping);
        griCodes.addAll(topics.environmental.waste.griMapping);
        griCodes.addAll(topics.environmental.materials.griMapping);
        break;
      case 'Social':
        griCodes.addAll(topics.social.workforce.griMapping);
        griCodes.addAll(topics.social.healthSafety.griMapping);
        griCodes.addAll(topics.social.training.griMapping);
        griCodes.addAll(topics.social.diversityEquity.griMapping);
        break;
      case 'Governance':
        griCodes.addAll(topics.governance.ethicsAnticorruption.griMapping);
        griCodes.addAll(topics.governance.dataPrivacySecurity.griMapping);
        griCodes.addAll(topics.governance.boardGovernance.griMapping);
        griCodes.addAll(topics.governance.supplyChain.griMapping);
        break;
    }
    
    return griCodes;
  }

  // Helper to extract all SDG codes from a category
  Set<String> _getSdgsForCategory(String category) {
    final topics = widget.company.topics;
    Set<String> sdgs = {};
    
    switch (category) {
      case 'Environmental':
        sdgs.addAll(topics.environmental.energyClimate.sdgMapping);
        sdgs.addAll(topics.environmental.water.sdgMapping);
        sdgs.addAll(topics.environmental.waste.sdgMapping);
        sdgs.addAll(topics.environmental.materials.sdgMapping);
        break;
      case 'Social':
        sdgs.addAll(topics.social.workforce.sdgMapping);
        sdgs.addAll(topics.social.healthSafety.sdgMapping);
        sdgs.addAll(topics.social.training.sdgMapping);
        sdgs.addAll(topics.social.diversityEquity.sdgMapping);
        break;
      case 'Governance':
        sdgs.addAll(topics.governance.ethicsAnticorruption.sdgMapping);
        sdgs.addAll(topics.governance.dataPrivacySecurity.sdgMapping);
        sdgs.addAll(topics.governance.boardGovernance.sdgMapping);
        sdgs.addAll(topics.governance.supplyChain.sdgMapping);
        break;
    }
    
    return sdgs;
  }

  // Helper to calculate category scores from topic scores using GRI mappings
  Map<String, CategoryData> _calculateCategoryData() {
    final categories = ['Environmental', 'Social', 'Governance'];
    final result = <String, CategoryData>{};
    
    for (final category in categories) {
      final griCodes = _getGriCodesForCategory(category);
      final sdgs = _getSdgsForCategory(category);
      
      // Find matching scores in report
      final matchingScores = widget.company.report.topicScores
          .where((score) => griCodes.contains(score.topicCode))
          .toList();
      
      // Calculate average score
      double avgScore = 0;
      if (matchingScores.isNotEmpty) {
        avgScore = matchingScores.fold(0.0, (sum, t) => sum + t.score) / matchingScores.length;
      }
      
      result[category] = CategoryData(
        score: avgScore,
        griCodes: griCodes,
        sdgs: sdgs.toList()..sort(),
        topicScores: matchingScores,
      );
    }
    
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = _calculateCategoryData();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      child: isDesktop
          ? _buildDesktopLayout(categoryData)
          : _buildMobileLayout(categoryData),
    );
  }

  Widget _buildDesktopLayout(Map<String, CategoryData> categoryData) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Overall Score Circle
        Expanded(
          flex: 2,
          child: _buildOverallScoreCircle(),
        ),
        const SizedBox(width: 32),
        // Category Scores
        Expanded(
          flex: 3,
          child: _buildCategoryScores(categoryData),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Map<String, CategoryData> categoryData) {
    return Column(
      children: [
        _buildOverallScoreCircle(),
        const SizedBox(height: 24),
        _buildCategoryScores(categoryData),
      ],
    );
  }

  Widget _buildOverallScoreCircle() {
    final score = widget.company.report.overallScore;
    
    return Container(
      constraints: const BoxConstraints(maxWidth: 280, maxHeight: 280),
      child: AspectRatio(
        aspectRatio: 1,
        child: CustomPaint(
          painter: _CircularScorePainter(
            score: score,
            color: _getScoreColor(score),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Overall Score',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${score.toInt()}',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(score),
                    height: 1,
                  ),
                ),
                Text(
                  '/100',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryScores(Map<String, CategoryData> categoryData) {
    return Column(
      children: [
        _buildCategoryCard(
          'Environmental',
          categoryData['Environmental']!,
          const Color(0xFF4CAF50),
          Icons.eco_outlined,
        ),
        const SizedBox(height: 16),
        _buildCategoryCard(
          'Social',
          categoryData['Social']!,
          const Color(0xFFFF9800),
          Icons.people_outline,
        ),
        const SizedBox(height: 16),
        _buildCategoryCard(
          'Governance',
          categoryData['Governance']!,
          const Color(0xFF2196F3),
          Icons.shield_outlined,
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, CategoryData data, Color color, IconData icon) {
    final isExpanded = _expandedCategory == title;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expandedCategory = isExpanded ? null : title;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${data.score.toInt()}',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(height: 1, color: Colors.grey[200]),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data.griCodes.isNotEmpty || data.sdgs.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data.griCodes.isNotEmpty) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GRI Topics: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.griCodes.join(', '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (data.griCodes.isNotEmpty && data.sdgs.isNotEmpty)
                            const SizedBox(height: 8),
                          if (data.sdgs.isNotEmpty) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'SDGs: ',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data.sdgs.join(', '),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Topic Scores
                  if (data.topicScores.isNotEmpty) ...[
                    Text(
                      'Topic Scores',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...data.topicScores.map((topicScore) => _buildTopicScoreItem(
                      topicScore,
                      color,
                    )),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopicScoreItem(TopicScore topicScore, Color categoryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: categoryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: categoryColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  topicScore.topicCode,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${topicScore.score.toInt()}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: categoryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Completeness: ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${(topicScore.completeness * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: topicScore.completeness,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(categoryColor),
            minHeight: 4,
          ),
          if (topicScore.notes != null && topicScore.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...topicScore.notes!.map((note) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      note,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 70) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }
}

class _CircularScorePainter extends CustomPainter {
  final double score;
  final Color color;

  _CircularScorePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 20;
    final strokeWidth = 16.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Score arc
    final scorePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * math.pi;
    const startAngle = -math.pi / 2; // Start from top

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(_CircularScorePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}