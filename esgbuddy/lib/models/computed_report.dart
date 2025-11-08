/// Model for Topic Score
class TopicScore {
  final String topicCode;
  final double score;
  final double completeness;
  final List<String>? notes;

  TopicScore({
    required this.topicCode,
    required this.score,
    required this.completeness,
    this.notes,
  });

  factory TopicScore.fromJson(Map<String, dynamic> json) {
    return TopicScore(
      topicCode: json['topic_code'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
      completeness: (json['completeness'] ?? 0).toDouble(),
      notes: json['notes'] != null ? List<String>.from(json['notes']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic_code': topicCode,
      'score': score,
      'completeness': completeness,
      'notes': notes,
    };
  }
}

/// Model for SDG Score
class SdgScore {
  final int sdg;
  final double score;
  final List<String> materialTopicsContributing;

  SdgScore({
    required this.sdg,
    required this.score,
    required this.materialTopicsContributing,
  });

  factory SdgScore.fromJson(Map<String, dynamic> json) {
    return SdgScore(
      sdg: json['sdg'] ?? 0,
      score: (json['score'] ?? 0).toDouble(),
      materialTopicsContributing:
          List<String>.from(json['material_topics_contributing'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sdg': sdg,
      'score': score,
      'material_topics_contributing': materialTopicsContributing,
    };
  }
}

/// Model for Content Index
class ContentIndex {
  final String standard;
  final String disclosureCode;
  final String disclosureTitle;
  final String location;

  ContentIndex({
    required this.standard,
    required this.disclosureCode,
    required this.disclosureTitle,
    required this.location,
  });

  factory ContentIndex.fromJson(Map<String, dynamic> json) {
    return ContentIndex(
      standard: json['standard'] ?? '',
      disclosureCode: json['disclosure_code'] ?? '',
      disclosureTitle: json['disclosure_title'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

/// Model for QA section
class ReportQA {
  final double completenessPct;
  final bool hasExternalAssurance;
  final String statementOfUse;

  ReportQA({
    required this.completenessPct,
    required this.hasExternalAssurance,
    required this.statementOfUse,
  });

  factory ReportQA.fromJson(Map<String, dynamic> json) {
    return ReportQA(
      completenessPct: (json['completeness_pct'] ?? 0).toDouble(),
      hasExternalAssurance: json['has_external_assurance'] ?? false,
      statementOfUse: json['statement_of_use'] ?? '',
    );
  }
}

/// Model for Computed Report
class ComputedReport {
  final String reportId;
  final String companyId;
  final int fiscalYear;
  final double overallScore;
  final List<TopicScore> topicScores;
  final List<SdgScore> sdgScores;
  final List<ContentIndex> contentIndex;
  final ReportQA qa;

  ComputedReport({
    required this.reportId,
    required this.companyId,
    required this.fiscalYear,
    required this.overallScore,
    required this.topicScores,
    required this.sdgScores,
    required this.contentIndex,
    required this.qa,
  });

  factory ComputedReport.fromJson(Map<String, dynamic> json) {
    final reportRef = json['report_ref'] ?? {};
    
    return ComputedReport(
      reportId: reportRef['report_id'] ?? '',
      companyId: reportRef['company_id'] ?? '',
      fiscalYear: reportRef['fiscal_year'] ?? 0,
      overallScore: (json['overall_score'] ?? 0).toDouble(),
      topicScores: (json['topic_scores'] as List?)
              ?.map((e) => TopicScore.fromJson(e))
              .toList() ??
          [],
      sdgScores: (json['sdg_scores'] as List?)
              ?.map((e) => SdgScore.fromJson(e))
              .toList() ??
          [],
      contentIndex: (json['content_index'] as List?)
              ?.map((e) => ContentIndex.fromJson(e))
              .toList() ??
          [],
      qa: ReportQA.fromJson(json['qa'] ?? {}),
    );
  }
}
