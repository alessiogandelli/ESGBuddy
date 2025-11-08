import 'computed_report.dart';
import 'topics_data.dart';

/// Model for Financial Metrics
class FinancialMetrics {
  final String currency;
  final double annualRevenue;
  final double ebitda;
  final double totalAssets;
  final double rdInvestment;
  final double capex;
  final double sustainabilityInvestment;

  FinancialMetrics({
    required this.currency,
    required this.annualRevenue,
    required this.ebitda,
    required this.totalAssets,
    required this.rdInvestment,
    required this.capex,
    required this.sustainabilityInvestment,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      currency: json['currency'] ?? 'EUR',
      annualRevenue: (json['annual_revenue'] ?? 0).toDouble(),
      ebitda: (json['ebitda'] ?? 0).toDouble(),
      totalAssets: (json['total_assets'] ?? 0).toDouble(),
      rdInvestment: (json['rd_investment'] ?? 0).toDouble(),
      capex: (json['capex'] ?? 0).toDouble(),
      sustainabilityInvestment: (json['sustainability_investment'] ?? 0).toDouble(),
    );
  }

  double get ebitdaMargin => annualRevenue > 0 ? (ebitda / annualRevenue) * 100 : 0;
  double get rdIntensity => annualRevenue > 0 ? (rdInvestment / annualRevenue) * 100 : 0;
  double get sustainabilityIntensity => annualRevenue > 0 ? (sustainabilityInvestment / annualRevenue) * 100 : 0;
}

/// Model for Company Basic Information
class CompanyBasicInfo {
  final String legalName;
  final String tradeName;
  final String industry;
  final String sector;
  final String country;
  final FinancialMetrics? financialMetrics;

  CompanyBasicInfo({
    required this.legalName,
    required this.tradeName,
    required this.industry,
    required this.sector,
    required this.country,
    this.financialMetrics,
  });

  factory CompanyBasicInfo.fromJson(Map<String, dynamic> json) {
    final basicInfo = json['basic_information'] ?? {};
    final industryData = basicInfo['industry'] ?? {};
    final headquarters = basicInfo['headquarters'] ?? {};
    final financialData = json['financial_metrics'];

    return CompanyBasicInfo(
      legalName: basicInfo['legal_name'] ?? '',
      tradeName: basicInfo['trade_name'] ?? '',
      industry: industryData['sector'] ?? '',
      sector: industryData['subsector'] ?? '',
      country: headquarters['country'] ?? '',
      financialMetrics: financialData != null 
          ? FinancialMetrics.fromJson(financialData)
          : null,
    );
  }
}

/// Complete Company ESG Data Model
class CompanyESGData {
  final String id;
  final String reportId;
  final String companyId;
  final int fiscalYear;
  final CompanyBasicInfo basicInfo;
  final ComputedReport report;
  final TopicsData topics;
  final DateTime createdAt;

  CompanyESGData({
    required this.id,
    required this.reportId,
    required this.companyId,
    required this.fiscalYear,
    required this.basicInfo,
    required this.report,
    required this.topics,
    required this.createdAt,
  });

  factory CompanyESGData.fromJson(Map<String, dynamic> json) {
    final metadata = json['report_metadata'] ?? {};
    final reportingPeriod = metadata['reporting_period'] ?? {};
    final companyProfile = json['company_profile'] ?? {};

    // Parse _id - can be string or MongoDB object
    String parseId(dynamic id) {
      if (id == null) return '';
      if (id is String) return id;
      if (id is Map && id.containsKey('\$oid')) {
        return id['\$oid'].toString();
      }
      return id.toString();
    }

    return CompanyESGData(
      id: parseId(json['_id']),
      reportId: metadata['report_id']?.toString() ?? '',
      companyId: metadata['company_id']?.toString() ?? '',
      fiscalYear: (reportingPeriod['fiscal_year'] is int) 
          ? reportingPeriod['fiscal_year'] 
          : int.tryParse(reportingPeriod['fiscal_year']?.toString() ?? '0') ?? 0,
      basicInfo: CompanyBasicInfo.fromJson(companyProfile),
      report: ComputedReport.fromJson(json['report'] ?? {}),
      topics: TopicsData.fromJson(json['topics'] ?? {}),
      createdAt: _parseDate(json['created_at']),
    );
  }

  static DateTime _parseDate(dynamic dateData) {
    if (dateData == null) return DateTime.now();
    if (dateData is String) return DateTime.parse(dateData);
    if (dateData is Map && dateData.containsKey('\$date')) {
      final dateStr = dateData['\$date'];
      if (dateStr is String) return DateTime.parse(dateStr);
    }
    return DateTime.now();
  }

  // Convenience getters
  String get companyName => basicInfo.tradeName;
  double get overallScore => report.overallScore;
  List<TopicScore> get topicScores => report.topicScores;
  List<SdgScore> get sdgScores => report.sdgScores;
}

/// Summary Statistics Model
class ESGSummaryStats {
  final int totalCompanies;
  final double averageOverallScore;
  final int companiesWithAssurance;
  final double averageCompleteness;

  ESGSummaryStats({
    required this.totalCompanies,
    required this.averageOverallScore,
    required this.companiesWithAssurance,
    required this.averageCompleteness,
  });

  factory ESGSummaryStats.fromJson(Map<String, dynamic> json) {
    return ESGSummaryStats(
      totalCompanies: json['total_companies'] ?? 0,
      averageOverallScore: (json['average_overall_score'] ?? 0).toDouble(),
      companiesWithAssurance: json['companies_with_assurance'] ?? 0,
      averageCompleteness: (json['average_completeness'] ?? 0).toDouble(),
    );
  }
}
