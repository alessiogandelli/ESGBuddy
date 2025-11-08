import 'package:esgbuddy/models/company_esg_data.dart';
import 'package:flutter/material.dart';

class DashboardTitle extends StatelessWidget {
  final CompanyESGData company;

  const DashboardTitle({
    super.key,
    required this.company,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: _buildDecoration(context),
      child: _buildContent(context),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor.withOpacity(0.7),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyName(context),
        const SizedBox(height: 8),
        _buildSubtitle(context),
      ],
    );
  }

  Widget _buildCompanyName(BuildContext context) {
    return Text(
      company.basicInfo.legalName,
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'ESG Dashboard',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white70,
          ),
    );
  }
}