import 'package:flutter/material.dart';
import '../../../models/computed_report.dart';
import '../../helpers/sdg_helper.dart';
import '../circular_score_indicator.dart';
import '../../helpers/gri_topic_helper.dart';

class SdgScoresSection extends StatelessWidget {
  final List<SdgScore> sdgScores;
  final bool isDesktop;

  const SdgScoresSection({
    super.key,
    required this.sdgScores,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.public,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        isDesktop
            ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: screenWidth > 1200 ? 5 : 4,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: sdgScores.length,
                itemBuilder: (context, index) {
                  return SdgCard(sdg: sdgScores[index], isDesktop: isDesktop);
                },
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sdgScores.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SdgCard(sdg: sdgScores[index], isDesktop: isDesktop),
                  );
                },
              ),
      ],
    );
  }
}

class SdgCard extends StatelessWidget {
  final SdgScore sdg;
  final bool isDesktop;

  const SdgCard({super.key, required this.sdg, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final sdgInfo = SdgHelper.getInfo(sdg.sdg);
    if (sdgInfo == null) return const SizedBox();

    if (isDesktop) {
      return _buildDesktopCard(context, sdgInfo);
    } else {
      return _buildMobileCard(context, sdgInfo);
    }
  }

  Widget _buildDesktopCard(BuildContext context, SdgInfo sdgInfo) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () => _showSdgDetails(context, sdgInfo),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularScoreIndicator(
                  score: sdg.score,
                  size: 100,
                  showLabel: false,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: sdgInfo.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: sdgInfo.color.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'SDG ${sdg.sdg}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sdgInfo.color,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  sdgInfo.name,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCard(BuildContext context, SdgInfo sdgInfo) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white,
        ),
        child: InkWell(
          onTap: () => _showSdgDetails(context, sdgInfo),
          borderRadius: BorderRadius.circular(16),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
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
      ),
    );
  }

  void _showSdgDetails(BuildContext context, SdgInfo sdgInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(sdgInfo.icon, color: sdgInfo.color),
            const SizedBox(width: 12),
            Expanded(child: Text('SDG ${sdg.sdg}: ${sdgInfo.name}')),
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
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...sdg.materialTopicsContributing.map(
                (topic) => Padding(
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
                ),
              ),
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

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Improvement';
  }
}
