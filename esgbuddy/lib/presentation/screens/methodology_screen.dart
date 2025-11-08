import 'package:flutter/material.dart';

class MethodologyScreen extends StatelessWidget {
  const MethodologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scoring Methodology'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildIntroSection(context),
            const SizedBox(height: 24),
            _buildScoringFormulaSection(context),
            const SizedBox(height: 24),
            _buildTopicsSection(context),
            const SizedBox(height: 24),
            _buildSDGSection(context),
            const SizedBox(height: 24),
            _buildMetricsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESG Scoring Framework',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our ESG scoring methodology is aligned with the Global Reporting Initiative (GRI) Standards, '
              'the world\'s most widely used framework for sustainability reporting.',
            ),
            const SizedBox(height: 12),
            const Text(
              'The scoring evaluates companies across 11 material topics spanning Environmental, '
              'Social, and Governance dimensions, with results mapped to UN Sustainable Development Goals (SDGs).',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoringFormulaSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scoring Formula',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Topic Score = (40% × Completeness) + (60% × Performance)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFormulaExplanation(
                    'Completeness (0-1)',
                    'Percentage of required GRI disclosures provided',
                  ),
                  _buildFormulaExplanation(
                    'Performance (0-100)',
                    'Metric-based scoring against industry benchmarks',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Overall Score: Weighted average of all topic scores, with emphasis on emissions and climate action.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaExplanation(String label, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GRI Topic Standards',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildTopicCategory(context, 'Environmental (E)', [
              _TopicInfo('GRI 302', 'Energy',
                  'Renewable energy %, energy intensity, year-over-year trends'),
              _TopicInfo('GRI 305', 'Emissions',
                  'Scope 1/2/3 emissions, intensity, reduction efforts'),
              _TopicInfo('GRI 303', 'Water and Effluents',
                  'Water consumption, recycling, water-stressed areas'),
              _TopicInfo(
                  'GRI 306', 'Waste', 'Recycling rate, hazardous waste management'),
            ]),
            const SizedBox(height: 16),
            _buildTopicCategory(context, 'Social (S)', [
              _TopicInfo('GRI 403', 'Occupational Health & Safety',
                  'TRIR, LTIR, fatalities, safety programs'),
              _TopicInfo('GRI 404', 'Training and Education',
                  'Training hours per employee, performance reviews'),
              _TopicInfo('GRI 405', 'Diversity and Equal Opportunity',
                  'Gender diversity, pay equity, representation'),
            ]),
            const SizedBox(height: 16),
            _buildTopicCategory(context, 'Governance (G)', [
              _TopicInfo('GRI 205', 'Anti-corruption',
                  'Training coverage, policy implementation, incidents'),
              _TopicInfo('GRI 418/419', 'Privacy & Compliance',
                  'Data breaches, certifications (ISO 27001, GDPR)'),
              _TopicInfo('GRI 2', 'Board Governance',
                  'Independence, diversity, attendance, committees'),
              _TopicInfo('GRI 308/414', 'Supply Chain',
                  'ESG assessments, Code of Conduct adoption'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCategory(
      BuildContext context, String category, List<_TopicInfo> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        ...topics.map((topic) => _buildTopicItem(context, topic)),
      ],
    );
  }

  Widget _buildTopicItem(BuildContext context, _TopicInfo topic) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${topic.code}: ${topic.name}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            topic.description,
            style: TextStyle(fontSize: 13, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildSDGSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UN SDG Alignment',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Each material topic is mapped to relevant UN Sustainable Development Goals. '
              'SDG scores are calculated by averaging the scores of contributing GRI topics.',
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSDGChip('SDG 3: Good Health', 'GRI 403'),
                _buildSDGChip('SDG 4: Quality Education', 'GRI 404'),
                _buildSDGChip('SDG 5: Gender Equality', 'GRI 405'),
                _buildSDGChip('SDG 6: Clean Water', 'GRI 303'),
                _buildSDGChip('SDG 7: Affordable Energy', 'GRI 302, 305'),
                _buildSDGChip('SDG 8: Decent Work', 'GRI 403, 404, 308/414'),
                _buildSDGChip('SDG 10: Reduced Inequalities', 'GRI 405'),
                _buildSDGChip('SDG 12: Responsible Consumption', 'GRI 306, 308/414'),
                _buildSDGChip('SDG 13: Climate Action', 'GRI 305'),
                _buildSDGChip('SDG 16: Peace & Justice', 'GRI 205, 418/419'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSDGChip(String label, String topics) {
    return Chip(
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(topics, style: const TextStyle(fontSize: 11)),
        ],
      ),
      backgroundColor: Colors.blue[50],
    );
  }

  Widget _buildMetricsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            _buildMetricCategory(context, 'Energy & Climate', [
              'Renewable energy percentage',
              'Energy intensity (kWh per EUR revenue)',
              'Scope 1, 2, 3 emissions (tCO₂e)',
              'Emissions intensity (tCO₂e per M EUR)',
              'Year-over-year intensity trends',
            ]),
            _buildMetricCategory(context, 'Water & Waste', [
              'Water consumption (m³)',
              'Water recycling rate',
              'Waste recycling rate',
              'Hazardous waste management',
            ]),
            _buildMetricCategory(context, 'Workforce & Safety', [
              'TRIR (Total Recordable Injury Rate)',
              'LTIR (Lost Time Injury Rate)',
              'Training hours per employee',
              'Performance review coverage',
              'Gender diversity metrics',
              'Gender pay gap',
            ]),
            _buildMetricCategory(context, 'Governance', [
              'Board independence percentage',
              'Board diversity',
              'Anti-corruption training coverage',
              'Data breach incidents',
              'ISO/GDPR certifications',
              'Supplier ESG assessment rate',
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCategory(
      BuildContext context, String category, List<String> metrics) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 8),
          ...metrics.map((metric) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(metric)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _TopicInfo {
  final String code;
  final String name;
  final String description;

  _TopicInfo(this.code, this.name, this.description);
}
