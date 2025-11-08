class GriTopicHelper {
  static const Map<String, Map<String, String>> _topicData = {
    // Universal Standards
    'GRI-2': {
      'name': 'General Disclosures',
      'description': 'Organization details, governance, and reporting practices',
      'category': 'Universal',
    },
    'GRI-3': {
      'name': 'Material Topics',
      'description': 'Process for determining material topics',
      'category': 'Universal',
    },

    // Economic Topics
    'GRI-201': {
      'name': 'Economic Performance',
      'description': 'Direct economic value generated and distributed',
      'category': 'Economic',
    },
    'GRI-202': {
      'name': 'Market Presence',
      'description': 'Ratios of standard entry level wage by gender',
      'category': 'Economic',
    },
    'GRI-203': {
      'name': 'Indirect Economic Impacts',
      'description': 'Infrastructure investments and services supported',
      'category': 'Economic',
    },
    'GRI-204': {
      'name': 'Procurement Practices',
      'description': 'Proportion of spending on local suppliers',
      'category': 'Economic',
    },
    'GRI-205': {
      'name': 'Anti-corruption',
      'description': 'Operations assessed for corruption risks',
      'category': 'Economic',
    },
    'GRI-206': {
      'name': 'Anti-competitive Behavior',
      'description': 'Legal actions for anti-competitive behavior',
      'category': 'Economic',
    },
    'GRI-207': {
      'name': 'Tax',
      'description': 'Tax approach and governance',
      'category': 'Economic',
    },

    // Environmental Topics
    'GRI-301': {
      'name': 'Materials',
      'description': 'Materials used by weight or volume',
      'category': 'Environmental',
    },
    'GRI-302': {
      'name': 'Energy',
      'description': 'Energy consumption and intensity',
      'category': 'Environmental',
    },
    'GRI-303': {
      'name': 'Water & Effluents',
      'description': 'Water withdrawal, discharge and consumption',
      'category': 'Environmental',
    },
    'GRI-304': {
      'name': 'Biodiversity',
      'description': 'Operations in protected areas and impact on biodiversity',
      'category': 'Environmental',
    },
    'GRI-305': {
      'name': 'Emissions',
      'description': 'Direct and indirect greenhouse gas emissions',
      'category': 'Environmental',
    },
    'GRI-306': {
      'name': 'Waste',
      'description': 'Waste generation and disposal',
      'category': 'Environmental',
    },
    'GRI-308': {
      'name': 'Supplier Environmental Assessment',
      'description': 'New suppliers screened using environmental criteria',
      'category': 'Environmental',
    },

    // Social Topics
    'GRI-401': {
      'name': 'Employment',
      'description': 'New employee hires and employee turnover',
      'category': 'Social',
    },
    'GRI-402': {
      'name': 'Labor Relations',
      'description': 'Minimum notice periods regarding operational changes',
      'category': 'Social',
    },
    'GRI-403': {
      'name': 'Occupational Health & Safety',
      'description': 'Worker health and safety management system',
      'category': 'Social',
    },
    'GRI-404': {
      'name': 'Training & Education',
      'description': 'Average hours of training per employee',
      'category': 'Social',
    },
    'GRI-405': {
      'name': 'Diversity & Equal Opportunity',
      'description': 'Diversity of governance bodies and employees',
      'category': 'Social',
    },
    'GRI-406': {
      'name': 'Non-discrimination',
      'description': 'Incidents of discrimination and corrective actions',
      'category': 'Social',
    },
    'GRI-407': {
      'name': 'Freedom of Association',
      'description': 'Operations at risk for rights violations',
      'category': 'Social',
    },
    'GRI-408': {
      'name': 'Child Labor',
      'description': 'Operations at risk for incidents of child labor',
      'category': 'Social',
    },
    'GRI-409': {
      'name': 'Forced or Compulsory Labor',
      'description': 'Operations at risk for forced or compulsory labor',
      'category': 'Social',
    },
    'GRI-410': {
      'name': 'Security Practices',
      'description': 'Security personnel trained in human rights',
      'category': 'Social',
    },
    'GRI-411': {
      'name': 'Rights of Indigenous Peoples',
      'description': 'Incidents involving violations of indigenous rights',
      'category': 'Social',
    },
    'GRI-413': {
      'name': 'Local Communities',
      'description': 'Operations with local community engagement',
      'category': 'Social',
    },
    'GRI-414': {
      'name': 'Supplier Social Assessment',
      'description': 'New suppliers screened using social criteria',
      'category': 'Social',
    },
    'GRI-415': {
      'name': 'Public Policy',
      'description': 'Political contributions',
      'category': 'Social',
    },
    'GRI-416': {
      'name': 'Customer Health & Safety',
      'description': 'Assessment of health and safety impacts',
      'category': 'Social',
    },
    'GRI-417': {
      'name': 'Marketing & Labeling',
      'description': 'Requirements for product information and labeling',
      'category': 'Social',
    },
    'GRI-418': {
      'name': 'Customer Privacy',
      'description': 'Substantiated complaints concerning customer privacy',
      'category': 'Social',
    },
  };

  /// Normalize GRI codes to handle both "GRI 302" and "GRI-302" formats
  static String _normalizeCode(String code) {
    return code.toUpperCase()
        .replaceAll(' ', '-')
        .replaceAll('GRI-', 'GRI-')
        .trim();
  }

  static String getName(String topicCode) {
    final normalized = _normalizeCode(topicCode);
    
    // Try exact match first
    if (_topicData.containsKey(normalized)) {
      return _topicData[normalized]!['name']!;
    }
    
    // Try matching after normalization
    for (var key in _topicData.keys) {
      if (_normalizeCode(key) == normalized) {
        return _topicData[key]!['name']!;
      }
    }
    
    // Try partial match (e.g., "201" matches "GRI-201")
    for (var key in _topicData.keys) {
      final normalizedKey = _normalizeCode(key);
      if (normalizedKey.contains(normalized) || 
          normalized.contains(normalizedKey.replaceAll('GRI-', ''))) {
        return _topicData[key]!['name']!;
      }
    }
    
    return topicCode; // Return original code if not found
  }

  static String getDescription(String topicCode) {
    final normalized = _normalizeCode(topicCode);
    
    if (_topicData.containsKey(normalized)) {
      return _topicData[normalized]!['description']!;
    }
    
    for (var key in _topicData.keys) {
      if (_normalizeCode(key) == normalized) {
        return _topicData[key]!['description']!;
      }
    }
    
    // Try partial match
    for (var key in _topicData.keys) {
      final normalizedKey = _normalizeCode(key);
      if (normalizedKey.contains(normalized) || 
          normalized.contains(normalizedKey.replaceAll('GRI-', ''))) {
        return _topicData[key]!['description']!;
      }
    }
    
    return '';
  }

  static String getCategory(String topicCode) {
    final normalized = _normalizeCode(topicCode);
    
    if (_topicData.containsKey(normalized)) {
      return _topicData[normalized]!['category']!;
    }
    
    for (var key in _topicData.keys) {
      if (_normalizeCode(key) == normalized) {
        return _topicData[key]!['category']!;
      }
    }
    
    // Try partial match
    for (var key in _topicData.keys) {
      final normalizedKey = _normalizeCode(key);
      if (normalizedKey.contains(normalized) || 
          normalized.contains(normalizedKey.replaceAll('GRI-', ''))) {
        return _topicData[key]!['category']!;
      }
    }
    
    return 'Other';
  }

  static Map<String, dynamic>? getTopicInfo(String topicCode) {
    final normalized = _normalizeCode(topicCode);
    
    if (_topicData.containsKey(normalized)) {
      return {
        'code': normalized,
        ..._topicData[normalized]!,
      };
    }
    
    for (var key in _topicData.keys) {
      if (_normalizeCode(key) == normalized) {
        return {
          'code': key,
          ..._topicData[key]!,
        };
      }
    }
    
    // Try partial match
    for (var key in _topicData.keys) {
      final normalizedKey = _normalizeCode(key);
      if (normalizedKey.contains(normalized) || 
          normalized.contains(normalizedKey.replaceAll('GRI-', ''))) {
        return {
          'code': key,
          ..._topicData[key]!,
        };
      }
    }
    
    return null;
  }
}
