import 'package:flutter/material.dart';
import '../submit_data/submit_data_screen.dart';
import 'dart:html' as html;

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _openUrl(String url) {
    html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              Colors.blue.shade900,
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom App Bar matching app style
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.eco_rounded, color: Color(0xFF4CAF50), size: 28),
                  const SizedBox(width: 12),
                  const Text(
                    'About ESG Buddy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Content
                    Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHackathonBadge(),
                          const SizedBox(height: 40),
                          _buildIntroSection(),
                          const SizedBox(height: 60),
                          _buildHowItWorksSection(),
                          const SizedBox(height: 60),
                          _buildDataExampleSection(context),
                          const SizedBox(height: 60),
                          _buildFeaturesSection(),
                          const SizedBox(height: 60),
                          _buildCTASection(context),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHackathonBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade600, Colors.deepOrange.shade700],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          const Text(
            'Built in 24 hours @ NOI Hackathon 2025',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ESG Reporting Made Simple',
            style: TextStyle(
              color: Colors.blue.shade200,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ESG Buddy is an automated ESG reporting platform that transforms raw company data into comprehensive, standards-compliant ESG reports with AI-powered insights.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No more manual report generation, complex calculations, or compliance headaches. Just provide your data, and we handle the rest.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It Works',
          style: TextStyle(
            color: Colors.blue.shade200,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(child: _buildStep('1', 'Provide Your Data', 'Share your company metrics through our simple data format')),
            const SizedBox(width: 24),
            Expanded(child: _buildStep('2', 'Automatic Processing', 'Our backend computes scores according to GRI & SDG standards')),
            const SizedBox(width: 24),
            Expanded(child: _buildStep('3', 'Get Insights', 'View your dashboard with scores, trends, and AI recommendations')),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade700],
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataExampleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Data Format',
          style: TextStyle(
            color: Colors.blue.shade200,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: Text(
                'Companies can submit their ESG data using our interactive form:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubmitDataScreen()),
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Submit Your Data'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Requirements',
                style: TextStyle(
                  color: Colors.blue.shade300,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDataRequirement('Company Profile', 'Legal name, sector, location, financial metrics'),
              _buildDataRequirement('Environmental', 'Energy consumption, emissions (Scope 1-3), water usage, waste'),
              _buildDataRequirement('Social', 'Workforce data, health & safety, training, diversity metrics'),
              _buildDataRequirement('Governance', 'Supply chain, compliance, board composition'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade300),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Full data structure includes Environmental, Social, and Governance metrics covering GRI 301-419 standards',
                  style: TextStyle(
                    color: Colors.blue.shade200,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      {
        'icon': Icons.analytics_outlined,
        'title': 'GRI & SDG Compliance',
        'description': 'Automatic scoring against GRI Standards and UN SDG targets'
      },
      {
        'icon': Icons.auto_awesome,
        'title': 'AI-Powered Insights',
        'description': 'Get personalized recommendations on where to improve your ESG performance'
      },
      {
        'icon': Icons.dashboard_customize,
        'title': 'Interactive Dashboard',
        'description': 'Visual representation of your scores, trends, and benchmarks'
      },
      {
        'icon': Icons.verified_outlined,
        'title': 'Standards-Based',
        'description': 'Built on recognized frameworks: GRI Universal Standards 2021'
      },
      {
        'icon': Icons.speed,
        'title': 'Fast Processing',
        'description': 'From raw data to comprehensive report in minutes, not months'
      },
      {
        'icon': Icons.download_outlined,
        'title': 'Export Ready',
        'description': 'Download professional PDF reports for stakeholders'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Features',
          style: TextStyle(
            color: Colors.blue.shade200,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) {
            final feature = features[index];
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    color: Colors.blue.shade300,
                    size: 32,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    feature['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature['description'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.blue.shade900],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rocket_launch,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 24),
          const Text(
            'Made by StudyBuddy Team',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'This is a hackathon project showcasing automated ESG reporting.\nIf you want to bring this platform to production, we\'d love to hear from you!',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildLinkButton(
                'Visit StudyBuddy',
                Icons.language,
                () => _openUrl('https://studybuddy.it'),
                isPrimary: true,
              ),
              _buildLinkButton(
                'LinkedIn',
                Icons.business,
                () => _openUrl('https://www.linkedin.com/company/studybuddio'),
                isPrimary: false,
              ),
              _buildLinkButton(
                'GitHub (Open Source)',
                Icons.code,
                () => _openUrl('https://github.com/alessiogandelli/ESGBuddy'),
                isPrimary: false,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.open_in_new, color: Colors.white70, size: 18),
                    const SizedBox(width: 8),
                    const Text(
                      'Open Source Project',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Code available on GitHub - Free to use, modify, and distribute under open source license',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: Colors.white70, size: 20),
                SizedBox(width: 8),
                Text(
                  'Built in 24 hours @ NOI Hackathon 2025 | Bolzano, Italy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String label, IconData icon, VoidCallback onPressed, {required bool isPrimary}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isPrimary ? Colors.blue.shade900 : Colors.white),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isPrimary ? Colors.blue.shade900 : Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Colors.white : Colors.transparent,
        foregroundColor: isPrimary ? Colors.blue.shade900 : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.white, width: 2),
        ),
        elevation: isPrimary ? 8 : 0,
      ),
    );
  }

  Widget _buildDataRequirement(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.green.shade400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
