import 'package:flutter/material.dart';
import '../../../models/company_esg_data.dart';
import '../../helpers/gri_topic_helper.dart';
import '../circular_score_indicator.dart';

class ESGHeroCard extends StatefulWidget {
  final CompanyESGData company;
  final bool isDesktop;
  final Function(String?)? onPillarSelected;

  const ESGHeroCard({
    super.key,
    required this.company,
    required this.isDesktop,
    this.onPillarSelected,
  });

  @override
  State<ESGHeroCard> createState() => _ESGHeroCardState();
}

class _ESGHeroCardState extends State<ESGHeroCard> {
  String? selectedPillar;

  @override
  Widget build(BuildContext context) {
    final score = widget.company.overallScore;
    final color = _getScoreColor(score);
    final label = _getScoreLabel(score);

    // Calculate E/S/G scores
    final environmental = widget.company.topicScores
        .where(
          (t) => GriTopicHelper.getCategory(t.topicCode) == 'Environmental',
        )
        .toList();
    final social = widget.company.topicScores
        .where((t) => GriTopicHelper.getCategory(t.topicCode) == 'Social')
        .toList();
    final governance = widget.company.topicScores
        .where(
          (t) =>
              GriTopicHelper.getCategory(t.topicCode) == 'Economic' ||
              GriTopicHelper.getCategory(t.topicCode) == 'Universal',
        )
        .toList();

    final eScore = environmental.isEmpty
        ? 0.0
        : environmental.map((e) => e.score).reduce((a, b) => a + b) /
              environmental.length;
    final sScore = social.isEmpty
        ? 0.0
        : social.map((e) => e.score).reduce((a, b) => a + b) / social.length;
    final gScore = governance.isEmpty
        ? 0.0
        : governance.map((e) => e.score).reduce((a, b) => a + b) /
              governance.length;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.03)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.isDesktop ? 40.0 : 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.eco, color: color, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ESG Performance Overview',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Comprehensive sustainability performance rating',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Main content: Overall score on left, breakdown on right
              widget.isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left: Overall ESG Score
                        Expanded(
                          flex: 2,
                          child: _buildOverallScoreSection(
                            context,
                            score,
                            label,
                            color,
                          ),
                        ),
                        const SizedBox(width: 40),
                        // Right: E/S/G Breakdown
                        Expanded(
                          flex: 3,
                          child: _buildPillarBreakdown(
                            context,
                            eScore,
                            sScore,
                            gScore,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _buildOverallScoreSection(context, score, label, color),
                        const SizedBox(height: 32),
                        _buildPillarBreakdown(context, eScore, sScore, gScore),
                      ],
                    ),

              const SizedBox(height: 24),
              _buildScoreLegend(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScoreSection(
    BuildContext context,
    double score,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          'Overall Score',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 20),
        CircularScoreIndicator(
          score: score,
          size: widget.isDesktop ? 200 : 160,
          label: label,
        ),
      ],
    );
  }

  Widget _buildPillarBreakdown(
    BuildContext context,
    double eScore,
    double sScore,
    double gScore,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESG Breakdown',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        _buildPillarItem(
          context,
          'Environmental',
          eScore,
          Icons.forest,
          const Color(0xFF4CAF50),
          'Climate, energy, water, waste, and biodiversity',
        ),
        const SizedBox(height: 12),
        _buildPillarItem(
          context,
          'Social',
          sScore,
          Icons.people,
          const Color(0xFF2196F3),
          'Workforce, health & safety, diversity, and community',
        ),
        const SizedBox(height: 12),
        _buildPillarItem(
          context,
          'Governance',
          gScore,
          Icons.gavel,
          const Color(0xFF9C27B0),
          'Ethics, transparency, board structure, and compliance',
        ),
      ],
    );
  }

  Widget _buildPillarItem(
    BuildContext context,
    String title,
    double score,
    IconData icon,
    Color color,
    String description,
  ) {
    final isSelected = selectedPillar == title;
    final scoreColor = _getScoreColor(score);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedPillar = isSelected ? null : title;
          });
          widget.onPillarSelected?.call(selectedPillar);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? color.withOpacity(0.05) : Colors.white,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        // Score badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: scoreColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: scoreColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            score.toStringAsFixed(0),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: scoreColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: score / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected) ...[
                const SizedBox(width: 12),
                Icon(Icons.chevron_right, color: color, size: 24),
              ],
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
        _buildLegendItem(
          context,
          'Excellent',
          const Color(0xFF4CAF50),
          '80-100',
        ),
        _buildLegendItem(context, 'Good', const Color(0xFF8BC34A), '60-79'),
        _buildLegendItem(context, 'Fair', const Color(0xFFFF9800), '40-59'),
        _buildLegendItem(
          context,
          'Needs Improvement',
          const Color(0xFFF44336),
          '0-39',
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    Color color,
    String range,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ($range)',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
        ),
      ],
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return const Color(0xFF4CAF50);
    if (score >= 60) return const Color(0xFF8BC34A);
    if (score >= 40) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }
}
