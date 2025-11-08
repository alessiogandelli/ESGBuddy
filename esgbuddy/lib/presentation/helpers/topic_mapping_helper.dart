/// Helper class to map between database topic names and their corresponding GRI codes and SDGs
class TopicMappingHelper {
  /// Map of topic names to their properties
  static const Map<String, Map<String, dynamic>> _topicMappings = {
    // Environmental topics
    'energy_climate': {
      'display_name': 'Energy & Climate',
      'category': 'Environmental',
      'gri_codes': ['GRI 302', 'GRI 305'],
      'sdgs': [7, 13],
      'icon': 'bolt',
    },
    'water': {
      'display_name': 'Water & Effluents',
      'category': 'Environmental',
      'gri_codes': ['GRI 303'],
      'sdgs': [6],
      'icon': 'water_drop',
    },
    'waste': {
      'display_name': 'Waste',
      'category': 'Environmental',
      'gri_codes': ['GRI 306'],
      'sdgs': [12],
      'icon': 'delete',
    },
    'materials': {
      'display_name': 'Materials',
      'category': 'Environmental',
      'gri_codes': ['GRI 301'],
      'sdgs': [12],
      'icon': 'inventory_2',
    },
    
    // Social topics
    'workforce': {
      'display_name': 'Workforce',
      'category': 'Social',
      'gri_codes': ['GRI 401', 'GRI 405'],
      'sdgs': [5, 8, 10],
      'icon': 'people',
    },
    'health_safety': {
      'display_name': 'Health & Safety',
      'category': 'Social',
      'gri_codes': ['GRI 403'],
      'sdgs': [3, 8],
      'icon': 'health_and_safety',
    },
    'training': {
      'display_name': 'Training & Education',
      'category': 'Social',
      'gri_codes': ['GRI 404'],
      'sdgs': [4, 8],
      'icon': 'school',
    },
    'diversity_equity': {
      'display_name': 'Diversity & Equity',
      'category': 'Social',
      'gri_codes': ['GRI 405'],
      'sdgs': [5, 10],
      'icon': 'diversity_3',
    },
    
    // Governance topics
    'ethics_anticorruption': {
      'display_name': 'Ethics & Anti-corruption',
      'category': 'Governance',
      'gri_codes': ['GRI 205', 'GRI 419'],
      'sdgs': [16],
      'icon': 'gavel',
    },
    'data_privacy_security': {
      'display_name': 'Data Privacy & Security',
      'category': 'Governance',
      'gri_codes': ['GRI 418'],
      'sdgs': [16],
      'icon': 'lock',
    },
    'board_governance': {
      'display_name': 'Board Governance',
      'category': 'Governance',
      'gri_codes': ['GRI 2'],
      'sdgs': [16],
      'icon': 'corporate_fare',
    },
    'supply_chain': {
      'display_name': 'Supply Chain',
      'category': 'Governance',
      'gri_codes': ['GRI 308', 'GRI 414'],
      'sdgs': [8, 12],
      'icon': 'local_shipping',
    },
  };

  /// Get display name for a topic
  static String getDisplayName(String topicKey) {
    return _topicMappings[topicKey]?['display_name'] ?? topicKey;
  }

  /// Get category for a topic
  static String getCategory(String topicKey) {
    return _topicMappings[topicKey]?['category'] ?? 'Other';
  }

  /// Get GRI codes for a topic
  static List<String> getGriCodes(String topicKey) {
    final codes = _topicMappings[topicKey]?['gri_codes'];
    if (codes == null) return [];
    return List<String>.from(codes);
  }

  /// Get SDGs for a topic
  static List<int> getSdgs(String topicKey) {
    final sdgs = _topicMappings[topicKey]?['sdgs'];
    if (sdgs == null) return [];
    return List<int>.from(sdgs);
  }

  /// Get icon for a topic
  static String getIcon(String topicKey) {
    return _topicMappings[topicKey]?['icon'] ?? 'info';
  }

  /// Get all topics for a category
  static List<String> getTopicsForCategory(String category) {
    return _topicMappings.entries
        .where((entry) => entry.value['category'] == category)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get all topics
  static List<String> getAllTopics() {
    return _topicMappings.keys.toList();
  }

  /// Get topic info
  static Map<String, dynamic>? getTopicInfo(String topicKey) {
    if (!_topicMappings.containsKey(topicKey)) return null;
    return {
      'key': topicKey,
      ..._topicMappings[topicKey]!,
    };
  }

  /// Find topic by GRI code
  static String? findTopicByGriCode(String griCode) {
    final normalized = griCode.toUpperCase().replaceAll('-', ' ').trim();
    
    for (var entry in _topicMappings.entries) {
      final codes = List<String>.from(entry.value['gri_codes'] ?? []);
      if (codes.any((code) => 
          code.toUpperCase().replaceAll('-', ' ').trim() == normalized)) {
        return entry.key;
      }
    }
    return null;
  }

  /// Find topics by SDG
  static List<String> findTopicsBySdg(int sdg) {
    return _topicMappings.entries
        .where((entry) {
          final sdgs = List<int>.from(entry.value['sdgs'] ?? []);
          return sdgs.contains(sdg);
        })
        .map((entry) => entry.key)
        .toList();
  }
}
