import 'package:esgbuddy/models/company_esg_data.dart';
import 'package:esgbuddy/models/computed_report.dart';
import 'package:esgbuddy/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:esgbuddy/presentation/screens/methodology_screen.dart';
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
  final FilterFramework selectedFramework;
  final String? selectedCategory;
  final Function(String) onCategoryTap;

  const DashboardHero({
    super.key,
    required this.company,
    this.selectedFramework = FilterFramework.gri,
    this.selectedCategory,
    required this.onCategoryTap,
  });

  @override
  State<DashboardHero> createState() => _DashboardHeroState();
}

class _DashboardHeroState extends State<DashboardHero> {

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
    switch (widget.selectedFramework) {
      case FilterFramework.gri:
        return _calculateCategoryDataByGri();
      case FilterFramework.sdg:
        return _calculateCategoryDataBySdg();
    }
  }

  Map<String, CategoryData> _calculateCategoryDataByGri() {
    final categories = ['Environmental', 'Social', 'Governance'];
    final result = <String, CategoryData>{};
    
    for (final category in categories) {
      final griCodes = _getGriCodesForCategory(category);
      final sdgs = _getSdgsForCategory(category);
      
      // Find matching scores in report
      final matchingScores = widget.company.report.topicScores
          .where((score) => griCodes.any((gri) => 
              _normalizeGriCode(gri) == _normalizeGriCode(score.topicCode)))
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

  Map<String, CategoryData> _calculateCategoryDataBySdg() {
    final categories = ['Environmental', 'Social', 'Governance'];
    final result = <String, CategoryData>{};
    
    for (final category in categories) {
      final griCodes = _getGriCodesForCategory(category);
      final sdgs = _getSdgsForCategory(category);
      
      // Extract SDG numbers from strings like "SDG 7", "SDG 13"
      final sdgNumbers = sdgs
          .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^\d]'), '')))
          .whereType<int>()
          .toSet();
      
      // Find matching SDG scores
      final matchingSdgScores = widget.company.report.sdgScores
          .where((score) => sdgNumbers.contains(score.sdg))
          .toList();
      
      // Calculate average SDG score
      double avgScore = 0;
      if (matchingSdgScores.isNotEmpty) {
        avgScore = matchingSdgScores.fold(0.0, (sum, s) => sum + s.score) / matchingSdgScores.length;
      }
      
      // Get topic scores for display
      final matchingTopicScores = widget.company.report.topicScores
          .where((score) => griCodes.any((gri) => 
              _normalizeGriCode(gri) == _normalizeGriCode(score.topicCode)))
          .toList();
      
      result[category] = CategoryData(
        score: avgScore,
        griCodes: griCodes,
        sdgs: sdgs.toList()..sort(),
        topicScores: matchingTopicScores,
      );
    }
    
    return result;
  }

  String _normalizeGriCode(String code) {
    // Remove spaces, hyphens, and extract the main GRI number
    String normalized = code.toUpperCase().replaceAll(' ', '').replaceAll('-', '').trim();
    
    // If it doesn't start with GRI, add it
    if (!normalized.startsWith('GRI')) {
      normalized = 'GRI$normalized';
    }
    
    // Extract just the first 3 digits after GRI (e.g., GRI4011 -> GRI401, GRI302 -> GRI302)
    if (normalized.length > 6) {
      normalized = normalized.substring(0, 6); // "GRI" + 3 digits
    }
    
    return normalized;
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
    
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
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
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: Colors.grey[600],
            size: 24,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MethodologyScreen(),
              ),
            );
          },
          tooltip: 'View Scoring Methodology',
        ),
      ],
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
    final isSelected = widget.selectedCategory == title;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
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
              widget.onCategoryTap(title);
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
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.filter_alt,
                          color: color,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),

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