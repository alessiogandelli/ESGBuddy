import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../models/company_esg_data.dart';
import '../../../models/computed_report.dart';
import '../../widgets/company_selector.dart';

class ImproveScreen extends StatefulWidget {
  final CompanyESGData company;
  final List<CompanyESGData> companies;
  final Function(CompanyESGData) onCompanyChanged;

  const ImproveScreen({
    super.key,
    required this.company,
    required this.companies,
    required this.onCompanyChanged,
  });

  @override
  State<ImproveScreen> createState() => _ImproveScreenState();
}

class _ImproveScreenState extends State<ImproveScreen> {
  bool _isLoadingAiReport = false;
  String? _aiReport;

  Future<void> _generateAiReport() async {
    setState(() {
      _isLoadingAiReport = true;
      _aiReport = null;
    });

    try {
      // Prepare data for AI analysis - just send company ID
      final requestData = {
        'company_id': widget.company.id,
      };

      // Call n8n webhook
      final response = await http.post(
        Uri.parse('https://00229abdafd2.ngrok-free.app/webhook/ai-insights'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        final jsonResponse = json.decode(response.body);
        
        // Extract the text content from the nested structure
        // The structure is: response.output[0].content[0].text
        String reportText = '';
        
        if (jsonResponse is Map<String, dynamic>) {
          final output = jsonResponse['output'];
          if (output is List && output.isNotEmpty) {
            final firstOutput = output[0];
            if (firstOutput is Map<String, dynamic>) {
              final content = firstOutput['content'];
              if (content is List && content.isNotEmpty) {
                final firstContent = content[0];
                if (firstContent is Map<String, dynamic>) {
                  reportText = firstContent['text']?.toString() ?? '';
                }
              }
            }
          }
        }
        
        setState(() {
          _aiReport = reportText;
          _isLoadingAiReport = false;
        });
        
        // Show the report in a dialog
        if (mounted) {
          _showAiReportDialog();
        }
      } else {
        throw Exception('Failed to generate report: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoadingAiReport = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate AI report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildFormattedInsights() {
    if (_aiReport == null || _aiReport!.isEmpty) {
      return const Text('No insights available');
    }

    try {
      // Remove markdown code block markers if present
      String cleanedReport = _aiReport!;
      if (cleanedReport.contains('```json')) {
        cleanedReport = cleanedReport.replaceAll('```json', '').replaceAll('```', '').trim();
      }
      
      final reportData = json.decode(cleanedReport);
      final insights = reportData['insights'] as List?;
      
      if (insights == null || insights.isEmpty) {
        return Text(_aiReport!);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: insights.map((insight) {
          final title = insight['title'] ?? 'Insight';
          final insightText = insight['insight'] ?? '';
          final recommendation = insight['recommendation'] ?? '';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  insightText,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                if (recommendation.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green.shade700, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Recommendation',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                recommendation,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.4,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      );
    } catch (e) {
      // Fallback to plain text if parsing fails
      return Text(
        _aiReport!,
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Colors.black87,
        ),
      );
    }
  }

  void _showAiReportDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.purple.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AI Improvement Analysis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildFormattedInsights(),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<SdgScore> _getLowestScoringSdgs() {
    // Get all SDG scores and sort by score (lowest first)
    final sortedSdgs = List<SdgScore>.from(widget.company.report.sdgScores)
      ..sort((a, b) => a.score.compareTo(b.score));
    
    // Return top 5 lowest scoring SDGs (or all if less than 5)
    return sortedSdgs.take(5).toList();
  }

  String _getSdgTitle(int sdg) {
    // Map SDG numbers to their official titles
    final sdgTitles = {
      1: 'No Poverty',
      2: 'Zero Hunger',
      3: 'Good Health and Well-being',
      4: 'Quality Education',
      5: 'Gender Equality',
      6: 'Clean Water and Sanitation',
      7: 'Affordable and Clean Energy',
      8: 'Decent Work and Economic Growth',
      9: 'Industry, Innovation and Infrastructure',
      10: 'Reduced Inequalities',
      11: 'Sustainable Cities and Communities',
      12: 'Responsible Consumption and Production',
      13: 'Climate Action',
      14: 'Life Below Water',
      15: 'Life on Land',
      16: 'Peace, Justice and Strong Institutions',
      17: 'Partnerships for the Goals',
    };
    
    return 'SDG $sdg: ${sdgTitles[sdg] ?? 'Unknown'}';
  }

  IconData _getSdgIcon(int sdg) {
    // Map SDGs to relevant icons
    final sdgIcons = {
      3: Icons.health_and_safety_rounded,
      4: Icons.school_rounded,
      5: Icons.people_rounded,
      6: Icons.water_drop_rounded,
      7: Icons.bolt_rounded,
      8: Icons.work_rounded,
      10: Icons.balance_rounded,
      12: Icons.recycling_rounded,
      13: Icons.eco_rounded,
      16: Icons.gavel_rounded,
    };
    
    return sdgIcons[sdg] ?? Icons.star_outline_rounded;
  }

  Color _getScoreColor(double score) {
    // Color based on score: red (bad) to yellow (medium) to green (good)
    if (score >= 80) {
      return const Color(0xFF4CAF50); // Green - Good
    } else if (score >= 60) {
      return const Color(0xFFFFA726); // Orange - Medium
    } else {
      return const Color(0xFFEF5350); // Red - Problematic
    }
  }

  String _getImprovementDescription(int sdg, double score, List<String> topics) {
    final topicsText = topics.isEmpty ? 'various topics' : topics.join(', ');
    return 'Current score: ${score.toStringAsFixed(1)}/100 - Related to: $topicsText';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;
    final lowestScoringSdgs = _getLowestScoringSdgs();

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
                // Company Selector
                CompanySelector(
                  selectedCompany: widget.company,
                  companies: widget.companies,
                  onCompanyChanged: widget.onCompanyChanged,
                ),
                const SizedBox(height: 24),
                
                // Header
                Text(
                  'Areas of Improvement',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Top 5 SDGs where ${widget.company.basicInfo.tradeName} can enhance performance',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 32),

                // Improvement Areas based on lowest SDG scores
                if (lowestScoringSdgs.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'No SDG scores available for this company.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  )
                else
                  ...lowestScoringSdgs.map((sdg) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildImprovementCard(
                      context,
                      title: _getSdgTitle(sdg.sdg),
                      icon: _getSdgIcon(sdg.sdg),
                      color: _getScoreColor(sdg.score),
                      description: _getImprovementDescription(sdg.sdg, sdg.score, sdg.materialTopicsContributing),
                      score: sdg.score / 100, // Convert to 0-1 range
                      completeness: 1.0, // SDGs don't have completeness, assume 100%
                    ),
                  )),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoadingAiReport ? null : _generateAiReport,
        backgroundColor: Colors.purple.shade600,
        icon: _isLoadingAiReport
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.auto_awesome, color: Colors.white),
        label: Text(
          _isLoadingAiReport ? 'Generating...' : 'AI Analysis',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildImprovementCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String description,
    required double score,
    required double completeness,
  }) {
    final scorePercentage = (score * 100).toStringAsFixed(1);
    
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
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
          const SizedBox(height: 16),
          // Score indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Score',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: score,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$scorePercentage',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
