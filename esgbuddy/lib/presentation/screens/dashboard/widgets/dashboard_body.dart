import 'package:esgbuddy/models/company_esg_data.dart';
import 'package:esgbuddy/presentation/helpers/gri_topic_helper.dart';
import 'package:esgbuddy/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

class DashboardBody extends StatelessWidget {
  final CompanyESGData company;
  final FilterFramework selectedFramework;
  final String? selectedCategory;

  const DashboardBody({
    super.key,
    required this.company,
    required this.selectedFramework,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return selectedFramework == FilterFramework.gri
        ? _buildGriView()
        : _buildSdgView();
  }

  Widget _buildGriView() {
    // Filter topic scores by category if selected
    var topicScores = company.report.topicScores;
    
    if (selectedCategory != null) {
      // Get GRI codes for this category from the topics data
      final categoryGriCodes = _getGriCodesForCategory(selectedCategory!);
      topicScores = topicScores.where((score) {
        return categoryGriCodes.any((gri) => 
          _normalizeGriCode(gri) == _normalizeGriCode(score.topicCode));
      }).toList();
    }

    if (topicScores.isEmpty) {
      return _buildEmptyState('No GRI topics found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedCategory != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Filtered by: $selectedCategory',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ...topicScores.map((score) => _buildGriTopicCard(score)),
      ],
    );
  }

  Widget _buildSdgView() {
    // Filter SDG scores by category if selected
    var sdgScores = company.report.sdgScores;
    
    if (selectedCategory != null) {
      // Get SDG numbers for this category from the topics data
      final categorySdgs = _getSdgsForCategory(selectedCategory!);
      final sdgNumbers = categorySdgs
          .map((s) => int.tryParse(s.replaceAll(RegExp(r'[^\d]'), '')))
          .whereType<int>()
          .toSet();
      
      sdgScores = sdgScores.where((score) => sdgNumbers.contains(score.sdg)).toList();
    }

    if (sdgScores.isEmpty) {
      return _buildEmptyState('No SDG goals found');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedCategory != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              'Filtered by: $selectedCategory',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ...sdgScores.map((score) => _buildSdgCard(score)),
      ],
    );
  }

  Widget _buildGriTopicCard(score) {
    final name = GriTopicHelper.getName(score.topicCode);
    final description = GriTopicHelper.getDescription(score.topicCode);
    final category = GriTopicHelper.getCategory(score.topicCode);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Score circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getScoreColor(score.score).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${score.score.toInt()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(score.score),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          score.topicCode,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _getCategoryColor(category),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  // Completeness indicator
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: score.completeness,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getScoreColor(score.score),
                            ),
                            minHeight: 4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(score.completeness * 100).toInt()}% complete',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSdgCard(score) {
    final sdgName = _getSdgName(score.sdg);
    final sdgIcon = _getSdgIcon(score.sdg);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // SDG icon/number
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getSdgColor(score.sdg),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  sdgIcon,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SDG ${score.sdg}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _getSdgColor(score.sdg),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sdgName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Contributing topics
                  if (score.materialTopicsContributing.isNotEmpty) ...[
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: score.materialTopicsContributing.take(3).map<Widget>((topic) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            topic,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            // Score
            Text(
              '${score.score.toInt()}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: _getScoreColor(score.score),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // Helper methods
  List<String> _getGriCodesForCategory(String category) {
    final topics = company.topics;
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

  Set<String> _getSdgsForCategory(String category) {
    final topics = company.topics;
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

  Color _getScoreColor(double score) {
    if (score >= 70) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Environmental':
        return const Color(0xFF4CAF50);
      case 'Social':
        return const Color(0xFFFF9800);
      case 'Governance':
        return const Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  Color _getSdgColor(int sdg) {
    // SDG official colors (simplified)
    const colors = {
      3: Color(0xFF4C9F38),
      4: Color(0xFFC5192D),
      5: Color(0xFFFF3A21),
      6: Color(0xFF26BDE2),
      7: Color(0xFFFCC30B),
      8: Color(0xFFA21942),
      10: Color(0xFFDD1367),
      12: Color(0xFFBF8B2E),
      13: Color(0xFF3F7E44),
      16: Color(0xFF00689D),
    };
    return colors[sdg] ?? Colors.grey;
  }

  String _getSdgName(int sdg) {
    const names = {
      3: 'Good Health and Well-being',
      4: 'Quality Education',
      5: 'Gender Equality',
      6: 'Clean Water and Sanitation',
      7: 'Affordable and Clean Energy',
      8: 'Decent Work and Economic Growth',
      10: 'Reduced Inequalities',
      12: 'Responsible Consumption and Production',
      13: 'Climate Action',
      16: 'Peace, Justice and Strong Institutions',
    };
    return names[sdg] ?? 'Sustainable Development Goal';
  }

  String _getSdgIcon(int sdg) {
    return '$sdg'; // Just the number for now
  }
}
