/// Domain model for ESG metrics
class EsgMetric {
  final String id;
  final String name;
  final String category; // Environmental, Social, or Governance
  final double value;
  final String unit;
  final DateTime timestamp;

  EsgMetric({
    required this.id,
    required this.name,
    required this.category,
    required this.value,
    required this.unit,
    required this.timestamp,
  });

  factory EsgMetric.fromJson(Map<String, dynamic> json) {
    return EsgMetric(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      unit: json['unit'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'value': value,
      'unit': unit,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
