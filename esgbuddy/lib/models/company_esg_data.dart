import 'computed_report.dart';

/// Model for Company Basic Information
class CompanyBasicInfo {
  final String legalName;
  final String tradeName;
  final String industry;
  final String sector;
  final String country;

  CompanyBasicInfo({
    required this.legalName,
    required this.tradeName,
    required this.industry,
    required this.sector,
    required this.country,
  });

  factory CompanyBasicInfo.fromJson(Map<String, dynamic> json) {
    final basicInfo = json['basic_information'] ?? {};
    final industryData = basicInfo['industry'] ?? {};
    final headquarters = basicInfo['headquarters'] ?? {};

    return CompanyBasicInfo(
      legalName: basicInfo['legal_name'] ?? '',
      tradeName: basicInfo['trade_name'] ?? '',
      industry: industryData['sector'] ?? '',
      sector: industryData['subsector'] ?? '',
      country: headquarters['country'] ?? '',
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
  final DateTime createdAt;

  CompanyESGData({
    required this.id,
    required this.reportId,
    required this.companyId,
    required this.fiscalYear,
    required this.basicInfo,
    required this.report,
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
