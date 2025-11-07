import 'package:flutter/material.dart';
import '../../models/esg_metric.dart';
import '../../models/company_profile.dart';
import '../../data/i_esg_repository.dart';
import '../../config/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final IEsgRepository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CompanyProfile> _companies = [];
  List<EsgMetric> _metrics = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final companies = await widget.repository.getCompanies();
      final metrics = await widget.repository.getMetrics();

      setState(() {
        _companies = companies;
        _metrics = metrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ESG Buddy'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: AppTheme.iconSizeMedium,
                color: AppTheme.errorIconColor,
              ),
              SizedBox(height: AppTheme.paddingLarge),
              Text('Error loading data', style: AppTheme.titleStyle(context)),
              SizedBox(height: AppTheme.paddingSmall),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: AppTheme.secondaryTextStyle(),
              ),
              SizedBox(height: AppTheme.paddingLarge),
              ElevatedButton.icon(
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_companies.isEmpty && _metrics.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: AppTheme.iconSizeMedium,
              color: AppTheme.emptyStateIconColor,
            ),
            SizedBox(height: AppTheme.paddingLarge),
            Text('No data available', style: AppTheme.titleStyle(context)),
            SizedBox(height: AppTheme.paddingSmall),
            Text(
              'Connect your backend to start',
              style: AppTheme.secondaryTextStyle(),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: EdgeInsets.all(AppTheme.paddingLarge),
        children: [
          if (_companies.isNotEmpty) ...[
            Text('Companies', style: AppTheme.headlineStyle(context)),
            SizedBox(height: AppTheme.paddingMedium),
            ..._companies.map((company) => _CompanyCard(company: company)),
            SizedBox(height: AppTheme.paddingXLarge),
          ],
          if (_metrics.isNotEmpty) ...[
            Text('ESG Metrics', style: AppTheme.headlineStyle(context)),
            SizedBox(height: AppTheme.paddingMedium),
            ..._metrics.map((metric) => _MetricCard(metric: metric)),
          ],
        ],
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final CompanyProfile company;

  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppTheme.cardMargin),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    company.name,
                    style: AppTheme.titleStyle(context),
                  ),
                ),
                AppTheme.buildScoreBadge(company.esgScore),
              ],
            ),
            SizedBox(height: AppTheme.paddingSmall),
            Text(company.industry, style: AppTheme.secondaryTextStyle()),
            if (company.description.isNotEmpty) ...[
              SizedBox(height: AppTheme.paddingSmall),
              Text(company.description, style: AppTheme.bodyStyle(context)),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final EsgMetric metric;

  const _MetricCard({required this.metric});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: AppTheme.cardMargin),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.paddingLarge),
        child: Row(
          children: [
            AppTheme.buildCategoryIcon(metric.category),
            SizedBox(width: AppTheme.paddingLarge),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(metric.name, style: AppTheme.subtitleStyle(context)),
                  const SizedBox(height: 4),
                  Text(metric.category, style: AppTheme.smallTextStyle()),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  metric.value.toStringAsFixed(2),
                  style: AppTheme.titleStyle(context),
                ),
                Text(metric.unit, style: AppTheme.smallTextStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
