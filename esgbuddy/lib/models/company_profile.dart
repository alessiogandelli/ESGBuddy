/// Domain model for company profile
class CompanyProfile {
  final String id;
  final String name;
  final String industry;
  final double esgScore;
  final String description;

  CompanyProfile({
    required this.id,
    required this.name,
    required this.industry,
    required this.esgScore,
    this.description = '',
  });

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      industry: json['industry'] ?? '',
      esgScore: (json['esg_score'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'industry': industry,
      'esg_score': esgScore,
      'description': description,
    };
  }
}
