/// Models for ESG Topics Data - Environmental, Social, and Governance metrics

// ============================================================================
// ENVIRONMENTAL TOPICS
// ============================================================================

/// Energy & Climate Metrics
class EnergyClimateMetrics {
  final double electricityConsumedKwh;
  final double renewableEnergyPurchasedKwh;
  final double renewableEnergyPct;
  final double naturalGasM3;
  final double dieselLiters;
  final double scope1Tco2e;
  final double scope2MarketTco2e;
  final double scope2LocationTco2e;
  final double scope3SelectedTco2e;
  final double energyIntensityKwhPerEurRevenue;
  final double emissionsIntensityTco2ePerMEur;
  final double yoyEnergyIntensityChangePct;
  final double yoyEmissionsIntensityChangePct;

  EnergyClimateMetrics({
    required this.electricityConsumedKwh,
    required this.renewableEnergyPurchasedKwh,
    required this.renewableEnergyPct,
    required this.naturalGasM3,
    required this.dieselLiters,
    required this.scope1Tco2e,
    required this.scope2MarketTco2e,
    required this.scope2LocationTco2e,
    required this.scope3SelectedTco2e,
    required this.energyIntensityKwhPerEurRevenue,
    required this.emissionsIntensityTco2ePerMEur,
    required this.yoyEnergyIntensityChangePct,
    required this.yoyEmissionsIntensityChangePct,
  });

  factory EnergyClimateMetrics.fromJson(Map<String, dynamic> json) {
    return EnergyClimateMetrics(
      electricityConsumedKwh: (json['electricity_consumed_kwh'] ?? 0).toDouble(),
      renewableEnergyPurchasedKwh: (json['renewable_energy_purchased_kwh'] ?? 0).toDouble(),
      renewableEnergyPct: (json['renewable_energy_pct'] ?? 0).toDouble(),
      naturalGasM3: (json['natural_gas_m3'] ?? 0).toDouble(),
      dieselLiters: (json['diesel_liters'] ?? 0).toDouble(),
      scope1Tco2e: (json['scope1_tco2e'] ?? 0).toDouble(),
      scope2MarketTco2e: (json['scope2_market_tco2e'] ?? 0).toDouble(),
      scope2LocationTco2e: (json['scope2_location_tco2e'] ?? 0).toDouble(),
      scope3SelectedTco2e: (json['scope3_selected_tco2e'] ?? 0).toDouble(),
      energyIntensityKwhPerEurRevenue: (json['energy_intensity_kwh_per_eur_revenue'] ?? 0).toDouble(),
      emissionsIntensityTco2ePerMEur: (json['emissions_intensity_tco2e_per_m_eur'] ?? 0).toDouble(),
      yoyEnergyIntensityChangePct: (json['yoy_energy_intensity_change_pct'] ?? 0).toDouble(),
      yoyEmissionsIntensityChangePct: (json['yoy_emissions_intensity_change_pct'] ?? 0).toDouble(),
    );
  }
}

/// Energy & Climate Targets
class EnergyClimateTargets {
  final double renewableEnergyTargetPct;
  final int scope12NetZeroYear;
  final double scope3CoveragePctTarget;
  final int targetYear;

  EnergyClimateTargets({
    required this.renewableEnergyTargetPct,
    required this.scope12NetZeroYear,
    required this.scope3CoveragePctTarget,
    required this.targetYear,
  });

  factory EnergyClimateTargets.fromJson(Map<String, dynamic> json) {
    return EnergyClimateTargets(
      renewableEnergyTargetPct: (json['renewable_energy_target_pct'] ?? 0).toDouble(),
      scope12NetZeroYear: json['scope1_2_net_zero_year'] ?? 0,
      scope3CoveragePctTarget: (json['scope3_coverage_pct_target'] ?? 0).toDouble(),
      targetYear: json['target_year'] ?? 0,
    );
  }
}

/// Energy & Climate Topic
class EnergyClimateTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final EnergyClimateMetrics metrics;
  final EnergyClimateTargets targets;

  EnergyClimateTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
    required this.targets,
  });

  factory EnergyClimateTopic.fromJson(Map<String, dynamic> json) {
    return EnergyClimateTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: EnergyClimateMetrics.fromJson(json['metrics'] ?? {}),
      targets: EnergyClimateTargets.fromJson(json['targets'] ?? {}),
    );
  }
}

/// Water Metrics
class WaterMetrics {
  final double waterWithdrawalM3;
  final double waterDischargeM3;
  final double waterConsumptionM3;
  final double waterRecycledM3;
  final int sitesInWaterStressedAreas;
  final double waterIntensityM3PerEurRevenue;
  final double yoyWaterIntensityChangePct;

  WaterMetrics({
    required this.waterWithdrawalM3,
    required this.waterDischargeM3,
    required this.waterConsumptionM3,
    required this.waterRecycledM3,
    required this.sitesInWaterStressedAreas,
    required this.waterIntensityM3PerEurRevenue,
    required this.yoyWaterIntensityChangePct,
  });

  factory WaterMetrics.fromJson(Map<String, dynamic> json) {
    return WaterMetrics(
      waterWithdrawalM3: (json['water_withdrawal_m3'] ?? 0).toDouble(),
      waterDischargeM3: (json['water_discharge_m3'] ?? 0).toDouble(),
      waterConsumptionM3: (json['water_consumption_m3'] ?? 0).toDouble(),
      waterRecycledM3: (json['water_recycled_m3'] ?? 0).toDouble(),
      sitesInWaterStressedAreas: json['sites_in_water_stressed_areas'] ?? 0,
      waterIntensityM3PerEurRevenue: (json['water_intensity_m3_per_eur_revenue'] ?? 0).toDouble(),
      yoyWaterIntensityChangePct: (json['yoy_water_intensity_change_pct'] ?? 0).toDouble(),
    );
  }
}

/// Water Topic
class WaterTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final WaterMetrics metrics;

  WaterTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory WaterTopic.fromJson(Map<String, dynamic> json) {
    return WaterTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: WaterMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Waste Metrics
class WasteMetrics {
  final double wasteGeneratedT;
  final double wasteDivertedT;
  final double wasteDisposedT;
  final double hazardousWasteT;
  final double recyclingRatePct;

  WasteMetrics({
    required this.wasteGeneratedT,
    required this.wasteDivertedT,
    required this.wasteDisposedT,
    required this.hazardousWasteT,
    required this.recyclingRatePct,
  });

  factory WasteMetrics.fromJson(Map<String, dynamic> json) {
    return WasteMetrics(
      wasteGeneratedT: (json['waste_generated_t'] ?? 0).toDouble(),
      wasteDivertedT: (json['waste_diverted_t'] ?? 0).toDouble(),
      wasteDisposedT: (json['waste_disposed_t'] ?? 0).toDouble(),
      hazardousWasteT: (json['hazardous_waste_t'] ?? 0).toDouble(),
      recyclingRatePct: (json['recycling_rate_pct'] ?? 0).toDouble(),
    );
  }
}

/// Waste Topic
class WasteTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final WasteMetrics metrics;

  WasteTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory WasteTopic.fromJson(Map<String, dynamic> json) {
    return WasteTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: WasteMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Materials Metrics
class MaterialsMetrics {
  final double paperT;
  final double recycledContentPaperPct;
  final double plasticPackagingT;
  final double recyclablePackagingPct;

  MaterialsMetrics({
    required this.paperT,
    required this.recycledContentPaperPct,
    required this.plasticPackagingT,
    required this.recyclablePackagingPct,
  });

  factory MaterialsMetrics.fromJson(Map<String, dynamic> json) {
    return MaterialsMetrics(
      paperT: (json['paper_t'] ?? 0).toDouble(),
      recycledContentPaperPct: (json['recycled_content_paper_pct'] ?? 0).toDouble(),
      plasticPackagingT: (json['plastic_packaging_t'] ?? 0).toDouble(),
      recyclablePackagingPct: (json['recyclable_packaging_pct'] ?? 0).toDouble(),
    );
  }
}

/// Materials Topic
class MaterialsTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final MaterialsMetrics metrics;

  MaterialsTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory MaterialsTopic.fromJson(Map<String, dynamic> json) {
    return MaterialsTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: MaterialsMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Environmental Topics
class EnvironmentalTopics {
  final EnergyClimateTopic energyClimate;
  final WaterTopic water;
  final WasteTopic waste;
  final MaterialsTopic materials;

  EnvironmentalTopics({
    required this.energyClimate,
    required this.water,
    required this.waste,
    required this.materials,
  });

  factory EnvironmentalTopics.fromJson(Map<String, dynamic> json) {
    return EnvironmentalTopics(
      energyClimate: EnergyClimateTopic.fromJson(json['energy_climate'] ?? {}),
      water: WaterTopic.fromJson(json['water'] ?? {}),
      waste: WasteTopic.fromJson(json['waste'] ?? {}),
      materials: MaterialsTopic.fromJson(json['materials'] ?? {}),
    );
  }
}

// ============================================================================
// SOCIAL TOPICS
// ============================================================================

/// Workforce Metrics
class WorkforceMetrics {
  final int totalHeadcount;
  final int newHires;
  final int departures;
  final Map<String, int> employeesByGender;
  final int womenInManagement;
  final int womenOnBoard;

  WorkforceMetrics({
    required this.totalHeadcount,
    required this.newHires,
    required this.departures,
    required this.employeesByGender,
    required this.womenInManagement,
    required this.womenOnBoard,
  });

  factory WorkforceMetrics.fromJson(Map<String, dynamic> json) {
    return WorkforceMetrics(
      totalHeadcount: json['total_headcount'] ?? 0,
      newHires: json['new_hires'] ?? 0,
      departures: json['departures'] ?? 0,
      employeesByGender: Map<String, int>.from(json['employees_by_gender'] ?? {}),
      womenInManagement: json['women_in_management'] ?? 0,
      womenOnBoard: json['women_on_board'] ?? 0,
    );
  }
}

/// Workforce Topic
class WorkforceTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final WorkforceMetrics metrics;

  WorkforceTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory WorkforceTopic.fromJson(Map<String, dynamic> json) {
    return WorkforceTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: WorkforceMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Health & Safety Metrics
class HealthSafetyMetrics {
  final int totalHoursWorked;
  final int recordableInjuries;
  final int lostTimeInjuries;
  final int fatalities;
  final double trir;
  final double ltir;

  HealthSafetyMetrics({
    required this.totalHoursWorked,
    required this.recordableInjuries,
    required this.lostTimeInjuries,
    required this.fatalities,
    required this.trir,
    required this.ltir,
  });

  factory HealthSafetyMetrics.fromJson(Map<String, dynamic> json) {
    return HealthSafetyMetrics(
      totalHoursWorked: json['total_hours_worked'] ?? 0,
      recordableInjuries: json['recordable_injuries'] ?? 0,
      lostTimeInjuries: json['lost_time_injuries'] ?? 0,
      fatalities: json['fatalities'] ?? 0,
      trir: (json['trir'] ?? 0).toDouble(),
      ltir: (json['ltir'] ?? 0).toDouble(),
    );
  }
}

/// Health & Safety Topic
class HealthSafetyTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final HealthSafetyMetrics metrics;

  HealthSafetyTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory HealthSafetyTopic.fromJson(Map<String, dynamic> json) {
    return HealthSafetyTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: HealthSafetyMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Training Metrics
class TrainingMetrics {
  final int totalTrainingHours;
  final double avgTrainingHoursPerEmployee;
  final double trainingInvestmentEur;
  final double employeesReviewedPct;
  final double internalPromotionRatePct;

  TrainingMetrics({
    required this.totalTrainingHours,
    required this.avgTrainingHoursPerEmployee,
    required this.trainingInvestmentEur,
    required this.employeesReviewedPct,
    required this.internalPromotionRatePct,
  });

  factory TrainingMetrics.fromJson(Map<String, dynamic> json) {
    return TrainingMetrics(
      totalTrainingHours: json['total_training_hours'] ?? 0,
      avgTrainingHoursPerEmployee: (json['avg_training_hours_per_employee'] ?? 0).toDouble(),
      trainingInvestmentEur: (json['training_investment_eur'] ?? 0).toDouble(),
      employeesReviewedPct: (json['employees_reviewed_pct'] ?? 0).toDouble(),
      internalPromotionRatePct: (json['internal_promotion_rate_pct'] ?? 0).toDouble(),
    );
  }
}

/// Training Topic
class TrainingTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final TrainingMetrics metrics;

  TrainingTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory TrainingTopic.fromJson(Map<String, dynamic> json) {
    return TrainingTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: TrainingMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Diversity & Equity Metrics
class DiversityEquityMetrics {
  final double genderPayGapPct;
  final int employeesWithDisabilities;

  DiversityEquityMetrics({
    required this.genderPayGapPct,
    required this.employeesWithDisabilities,
  });

  factory DiversityEquityMetrics.fromJson(Map<String, dynamic> json) {
    return DiversityEquityMetrics(
      genderPayGapPct: (json['gender_pay_gap_pct'] ?? 0).toDouble(),
      employeesWithDisabilities: json['employees_with_disabilities'] ?? 0,
    );
  }
}

/// Diversity & Equity Topic
class DiversityEquityTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final DiversityEquityMetrics metrics;

  DiversityEquityTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory DiversityEquityTopic.fromJson(Map<String, dynamic> json) {
    return DiversityEquityTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: DiversityEquityMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Social Topics
class SocialTopics {
  final WorkforceTopic workforce;
  final HealthSafetyTopic healthSafety;
  final TrainingTopic training;
  final DiversityEquityTopic diversityEquity;

  SocialTopics({
    required this.workforce,
    required this.healthSafety,
    required this.training,
    required this.diversityEquity,
  });

  factory SocialTopics.fromJson(Map<String, dynamic> json) {
    return SocialTopics(
      workforce: WorkforceTopic.fromJson(json['workforce'] ?? {}),
      healthSafety: HealthSafetyTopic.fromJson(json['health_safety'] ?? {}),
      training: TrainingTopic.fromJson(json['training'] ?? {}),
      diversityEquity: DiversityEquityTopic.fromJson(json['diversity_equity'] ?? {}),
    );
  }
}

// ============================================================================
// GOVERNANCE TOPICS
// ============================================================================

/// Ethics & Anti-Corruption Metrics
class EthicsAnticorruptionMetrics {
  final bool codeOfConductExists;
  final double employeesTrainedCodeOfConductPct;
  final bool antiCorruptionPolicyExists;
  final double employeesTrainedAntiCorruptionPct;
  final int whistleblowerReports;
  final int confirmedCorruptionIncidents;
  final double legalFinesEur;

  EthicsAnticorruptionMetrics({
    required this.codeOfConductExists,
    required this.employeesTrainedCodeOfConductPct,
    required this.antiCorruptionPolicyExists,
    required this.employeesTrainedAntiCorruptionPct,
    required this.whistleblowerReports,
    required this.confirmedCorruptionIncidents,
    required this.legalFinesEur,
  });

  factory EthicsAnticorruptionMetrics.fromJson(Map<String, dynamic> json) {
    return EthicsAnticorruptionMetrics(
      codeOfConductExists: json['code_of_conduct_exists'] ?? false,
      employeesTrainedCodeOfConductPct: (json['employees_trained_code_of_conduct_pct'] ?? 0).toDouble(),
      antiCorruptionPolicyExists: json['anti_corruption_policy_exists'] ?? false,
      employeesTrainedAntiCorruptionPct: (json['employees_trained_anti_corruption_pct'] ?? 0).toDouble(),
      whistleblowerReports: json['whistleblower_reports'] ?? 0,
      confirmedCorruptionIncidents: json['confirmed_corruption_incidents'] ?? 0,
      legalFinesEur: (json['legal_fines_eur'] ?? 0).toDouble(),
    );
  }
}

/// Ethics & Anti-Corruption Topic
class EthicsAnticorruptionTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final EthicsAnticorruptionMetrics metrics;

  EthicsAnticorruptionTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory EthicsAnticorruptionTopic.fromJson(Map<String, dynamic> json) {
    return EthicsAnticorruptionTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: EthicsAnticorruptionMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Data Privacy & Security Metrics
class DataPrivacySecurityMetrics {
  final bool iso27001Certified;
  final bool gdprCompliant;
  final int dataBreaches;
  final int customerRecordsCompromised;
  final int penetrationTestsConducted;

  DataPrivacySecurityMetrics({
    required this.iso27001Certified,
    required this.gdprCompliant,
    required this.dataBreaches,
    required this.customerRecordsCompromised,
    required this.penetrationTestsConducted,
  });

  factory DataPrivacySecurityMetrics.fromJson(Map<String, dynamic> json) {
    return DataPrivacySecurityMetrics(
      iso27001Certified: json['iso_27001_certified'] ?? false,
      gdprCompliant: json['gdpr_compliant'] ?? false,
      dataBreaches: json['data_breaches'] ?? 0,
      customerRecordsCompromised: json['customer_records_compromised'] ?? 0,
      penetrationTestsConducted: json['penetration_tests_conducted'] ?? 0,
    );
  }
}

/// Data Privacy & Security Topic
class DataPrivacySecurityTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final DataPrivacySecurityMetrics metrics;

  DataPrivacySecurityTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory DataPrivacySecurityTopic.fromJson(Map<String, dynamic> json) {
    return DataPrivacySecurityTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: DataPrivacySecurityMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Board Governance Metrics
class BoardGovernanceMetrics {
  final int boardSize;
  final double independentDirectorsPct;
  final double boardGenderDiversityWomenPct;
  final double avgBoardAttendancePct;
  final bool sustainabilityCommitteeExists;

  BoardGovernanceMetrics({
    required this.boardSize,
    required this.independentDirectorsPct,
    required this.boardGenderDiversityWomenPct,
    required this.avgBoardAttendancePct,
    required this.sustainabilityCommitteeExists,
  });

  factory BoardGovernanceMetrics.fromJson(Map<String, dynamic> json) {
    return BoardGovernanceMetrics(
      boardSize: json['board_size'] ?? 0,
      independentDirectorsPct: (json['independent_directors_pct'] ?? 0).toDouble(),
      boardGenderDiversityWomenPct: (json['board_gender_diversity_women_pct'] ?? 0).toDouble(),
      avgBoardAttendancePct: (json['avg_board_attendance_pct'] ?? 0).toDouble(),
      sustainabilityCommitteeExists: json['sustainability_committee_exists'] ?? false,
    );
  }
}

/// Board Governance Topic
class BoardGovernanceTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final BoardGovernanceMetrics metrics;

  BoardGovernanceTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory BoardGovernanceTopic.fromJson(Map<String, dynamic> json) {
    return BoardGovernanceTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: BoardGovernanceMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Supply Chain Metrics
class SupplyChainMetrics {
  final int totalSuppliers;
  final double suppliersSignedCocPct;
  final double suppliersAuditedEsgPct;
  final double localSuppliersPct;
  final double procurementSpendLocalPct;
  final int supplierEsgViolations;
  final int supplierEsgViolationsRemediated;

  SupplyChainMetrics({
    required this.totalSuppliers,
    required this.suppliersSignedCocPct,
    required this.suppliersAuditedEsgPct,
    required this.localSuppliersPct,
    required this.procurementSpendLocalPct,
    required this.supplierEsgViolations,
    required this.supplierEsgViolationsRemediated,
  });

  factory SupplyChainMetrics.fromJson(Map<String, dynamic> json) {
    return SupplyChainMetrics(
      totalSuppliers: json['total_suppliers'] ?? 0,
      suppliersSignedCocPct: (json['suppliers_signed_coc_pct'] ?? 0).toDouble(),
      suppliersAuditedEsgPct: (json['suppliers_audited_esg_pct'] ?? 0).toDouble(),
      localSuppliersPct: (json['local_suppliers_pct'] ?? 0).toDouble(),
      procurementSpendLocalPct: (json['procurement_spend_local_pct'] ?? 0).toDouble(),
      supplierEsgViolations: json['supplier_esg_violations'] ?? 0,
      supplierEsgViolationsRemediated: json['supplier_esg_violations_remediated'] ?? 0,
    );
  }
}

/// Supply Chain Topic
class SupplyChainTopic {
  final List<String> griMapping;
  final List<String> sdgMapping;
  final SupplyChainMetrics metrics;

  SupplyChainTopic({
    required this.griMapping,
    required this.sdgMapping,
    required this.metrics,
  });

  factory SupplyChainTopic.fromJson(Map<String, dynamic> json) {
    return SupplyChainTopic(
      griMapping: List<String>.from(json['gri_mapping'] ?? []),
      sdgMapping: List<String>.from(json['sdg_mapping'] ?? []),
      metrics: SupplyChainMetrics.fromJson(json['metrics'] ?? {}),
    );
  }
}

/// Governance Topics
class GovernanceTopics {
  final EthicsAnticorruptionTopic ethicsAnticorruption;
  final DataPrivacySecurityTopic dataPrivacySecurity;
  final BoardGovernanceTopic boardGovernance;
  final SupplyChainTopic supplyChain;

  GovernanceTopics({
    required this.ethicsAnticorruption,
    required this.dataPrivacySecurity,
    required this.boardGovernance,
    required this.supplyChain,
  });

  factory GovernanceTopics.fromJson(Map<String, dynamic> json) {
    return GovernanceTopics(
      ethicsAnticorruption: EthicsAnticorruptionTopic.fromJson(json['ethics_anticorruption'] ?? {}),
      dataPrivacySecurity: DataPrivacySecurityTopic.fromJson(json['data_privacy_security'] ?? {}),
      boardGovernance: BoardGovernanceTopic.fromJson(json['board_governance'] ?? {}),
      supplyChain: SupplyChainTopic.fromJson(json['supply_chain'] ?? {}),
    );
  }
}

// ============================================================================
// ALL TOPICS
// ============================================================================

/// Complete Topics Data
class TopicsData {
  final EnvironmentalTopics environmental;
  final SocialTopics social;
  final GovernanceTopics governance;

  TopicsData({
    required this.environmental,
    required this.social,
    required this.governance,
  });

  factory TopicsData.fromJson(Map<String, dynamic> json) {
    return TopicsData(
      environmental: EnvironmentalTopics.fromJson(json['environmental'] ?? {}),
      social: SocialTopics.fromJson(json['social'] ?? {}),
      governance: GovernanceTopics.fromJson(json['governance'] ?? {}),
    );
  }
}
