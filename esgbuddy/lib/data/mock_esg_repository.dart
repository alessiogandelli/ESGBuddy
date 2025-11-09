import '../models/company_esg_data.dart';
import 'i_esg_repository.dart';

/// Mock repository for testing without backend
class MockEsgRepository implements IEsgRepository {
  // Mock data based on comprehensive ESG report
  static const Map<String, dynamic> _mockCompanyData = {
    "_id": "mock-greentech-2021",
    "report_metadata": {
      "report_id": "ESG-2021-DEMO-002",
      "company_id": "IT-GREENTECH-2021",
      "report_date": "2025-03-15",
      "reporting_period": {
        "start_date": "2021-01-01",
        "end_date": "2021-12-31",
        "fiscal_year": 2021,
        "currency": "EUR"
      },
      "statement_of_use": {
        "framework": "GRI Standards",
        "claim": "in accordance",
        "universal_standards": {
          "gri_1": "GRI 1: Foundation 2021",
          "gri_2": "GRI 2: General Disclosures 2021",
          "gri_3": "GRI 3: Material Topics 2021"
        },
        "topic_standards_used": [
          "GRI 301", "GRI 302", "GRI 303", "GRI 305", "GRI 306",
          "GRI 401", "GRI 403", "GRI 404", "GRI 405", "GRI 406",
          "GRI 205", "GRI 308", "GRI 414", "GRI 418", "GRI 419"
        ],
        "sector_standards_used": [],
        "external_assurance": {
          "assured": true,
          "assurance_provider": "EY Sustainability Services",
          "assurance_standard": "ISAE 3000",
          "assurance_scope": "Selected KPIs across E, S, G topics",
          "assurance_conclusion": "Limited assurance"
        }
      },
      "reporting_boundary": {
        "entities_included": ["Demo Company S.p.A.", "Demo Ops SRL"],
        "approach": "operational control",
        "exclusions": [],
        "changes_since_prior_period": "None"
      }
    },
    "company_profile": {
      "basic_information": {
        "legal_name": "GreenTech Solutions S.p.A.",
        "trade_name": "GreenTech",
        "headquarters": {
          "address": "Via Roma 12, 20100 Milano, Italy",
          "country": "Italy",
          "region": "Lombardy"
        },
        "industry": {
          "sector": "Technology",
          "subsector": "Software & IT Services",
          "gics_code": "451020",
          "nace_code": "62.01"
        },
        "company_type": "Private Limited Company",
        "year_founded": 2014,
        "website": "https://www.greentech.it"
      },
      "financial_metrics": {
        "currency": "EUR",
        "annual_revenue": 58000000,
        "ebitda": 6900000,
        "total_assets": 35000000,
        "rd_investment": 5000000,
        "capex": 3200000,
        "sustainability_investment": 800000
      },
      "workforce_profile": {
        "total_employees": 600,
        "total_fte": 430,
        "employees_by_contract": {"permanent": 400, "temporary": 30},
        "employees_by_type": {"full_time": 412, "part_time": 18},
        "contractors_non_employees": 30,
        "geographic_distribution": {"italy": 370, "other_eu": 40, "non_eu": 20}
      }
    },
    "materiality": {
      "stakeholder_engagement": [
        {
          "stakeholder_group": "Employees",
          "engagement_method": "Survey and focus groups",
          "key_issues": ["Training", "Pay equity", "Wellbeing"]
        },
        {
          "stakeholder_group": "Customers",
          "engagement_method": "Interviews",
          "key_issues": ["Data privacy", "Service reliability", "Low‑carbon solutions"]
        },
        {
          "stakeholder_group": "Suppliers",
          "engagement_method": "Questionnaires",
          "key_issues": ["Code of conduct", "Audits"]
        }
      ],
      "methodology": "Double materiality (impact and financial) using severity, likelihood, and stakeholder priority scoring",
      "material_topics": [
        {
          "topic_code": "GRI 305",
          "topic_name": "Emissions",
          "boundary": "Own ops S1/S2; selected S3 categories",
          "sdg_links": [
            {"sdg": 7, "targets": ["7.2", "7.3"]},
            {"sdg": 13, "targets": ["13.2"]}
          ],
          "gri_disclosures": ["305-1", "305-2", "305-3", "305-5"]
        }
      ]
    },
    "topics": {
      "environmental": {
        "energy_climate": {
          "gri_mapping": ["302-1", "302-3", "302-4", "305-1", "305-2", "305-3", "305-5"],
          "sdg_mapping": ["SDG 7", "SDG 13"],
          "metrics": {
            "electricity_consumed_kwh": 2700000,
            "renewable_energy_purchased_kwh": 2300000,
            "renewable_energy_pct": 93,
            "natural_gas_m3": 38000,
            "diesel_liters": 2500,
            "scope1_tco2e": 450,
            "scope2_market_tco2e": 200,
            "scope2_location_tco2e": 1000,
            "scope3_selected_tco2e": 7600,
            "energy_intensity_kwh_per_eur_revenue": 0.06,
            "emissions_intensity_tco2e_per_m_eur": 8.7,
            "yoy_energy_intensity_change_pct": -6,
            "yoy_emissions_intensity_change_pct": -5
          },
          "targets": {
            "renewable_energy_target_pct": 100,
            "scope1_2_net_zero_year": 2035,
            "scope3_coverage_pct_target": 70,
            "target_year": 2028
          }
        },
        "water": {
          "gri_mapping": ["303-3", "303-4", "303-5"],
          "sdg_mapping": ["SDG 6"],
          "metrics": {
            "water_withdrawal_m3": 8400,
            "water_discharge_m3": 7500,
            "water_consumption_m3": 7800,
            "water_recycled_m3": 1100,
            "sites_in_water_stressed_areas": 0,
            "water_intensity_m3_per_eur_revenue": 0.00016,
            "yoy_water_intensity_change_pct": -8
          }
        },
        "waste": {
          "gri_mapping": ["306-3", "306-4", "306-5"],
          "sdg_mapping": ["SDG 12"],
          "metrics": {
            "waste_generated_t": 42,
            "waste_diverted_t": 30,
            "waste_disposed_t": 12,
            "hazardous_waste_t": 1,
            "recycling_rate_pct": 88.5
          }
        },
        "materials": {
          "gri_mapping": ["301-1", "301-2", "301-3"],
          "sdg_mapping": ["SDG 12"],
          "metrics": {
            "paper_t": 7,
            "recycled_content_paper_pct": 85,
            "plastic_packaging_t": 1.8,
            "recyclable_packaging_pct": 95
          }
        }
      },
      "social": {
        "workforce": {
          "gri_mapping": ["401-1", "405-1"],
          "sdg_mapping": ["SDG 5", "SDG 8", "SDG 10"],
          "metrics": {
            "total_headcount": 430,
            "new_hires": 90,
            "departures": 50,
            "employees_by_gender": {"female": 180, "male": 250},
            "women_in_management": 30,
            "women_on_board": 2
          }
        },
        "health_safety": {
          "gri_mapping": ["403-1", "403-2", "403-9"],
          "sdg_mapping": ["SDG 3", "SDG 8"],
          "metrics": {
            "total_hours_worked": 880000,
            "recordable_injuries": 4,
            "lost_time_injuries": 2,
            "fatalities": 0,
            "trir": 0.91,
            "ltir": 0.45
          }
        },
        "training": {
          "gri_mapping": ["404-1", "404-2", "404-3"],
          "sdg_mapping": ["SDG 4", "SDG 8"],
          "metrics": {
            "total_training_hours": 11000,
            "avg_training_hours_per_employee": 25.7,
            "training_investment_eur": 420000,
            "employees_reviewed_pct": 93,
            "internal_promotion_rate_pct": 9.5
          }
        },
        "diversity_equity": {
          "gri_mapping": ["405-1", "405-2"],
          "sdg_mapping": ["SDG 5", "SDG 10"],
          "metrics": {
            "gender_pay_gap_pct": 1.2,
            "employees_with_disabilities": 12
          }
        }
      },
      "governance": {
        "ethics_anticorruption": {
          "gri_mapping": ["205-1", "205-2", "205-3", "419-1"],
          "sdg_mapping": ["SDG 16"],
          "metrics": {
            "code_of_conduct_exists": true,
            "employees_trained_code_of_conduct_pct": 100,
            "anti_corruption_policy_exists": true,
            "employees_trained_anti_corruption_pct": 100,
            "whistleblower_reports": 5,
            "confirmed_corruption_incidents": 0,
            "legal_fines_eur": 0
          }
        },
        "data_privacy_security": {
          "gri_mapping": ["418-1"],
          "sdg_mapping": ["SDG 16"],
          "metrics": {
            "iso_27001_certified": true,
            "gdpr_compliant": true,
            "data_breaches": 0,
            "customer_records_compromised": 0,
            "penetration_tests_conducted": 2
          }
        },
        "board_governance": {
          "gri_mapping": ["2-9", "2-10", "2-11", "2-12"],
          "sdg_mapping": ["SDG 16"],
          "metrics": {
            "board_size": 5,
            "independent_directors_pct": 40,
            "board_gender_diversity_women_pct": 40,
            "avg_board_attendance_pct": 96,
            "sustainability_committee_exists": true
          }
        },
        "supply_chain": {
          "gri_mapping": ["204-1", "308-1", "414-1", "414-2"],
          "sdg_mapping": ["SDG 8", "SDG 12"],
          "metrics": {
            "total_suppliers": 140,
            "suppliers_signed_coc_pct": 90,
            "suppliers_audited_esg_pct": 55,
            "local_suppliers_pct": 60,
            "procurement_spend_local_pct": 45,
            "supplier_esg_violations": 1,
            "supplier_esg_violations_remediated": 1
          }
        }
      }
    },
    "report": {
      "report_ref": {
        "report_id": "ESG-2021-DEMO-002",
        "company_id": "IT-GREENTECH-2021",
        "fiscal_year": 2021
      },
      "topic_scores": [
        {"topic_code": "GRI 302", "score": 76.7, "completeness": 1, "notes": null},
        {"topic_code": "GRI 305", "score": 83.3, "completeness": 1, "notes": null},
        {"topic_code": "GRI 303", "score": 81.5, "completeness": 1, "notes": null},
        {"topic_code": "GRI 306", "score": 90.9, "completeness": 1, "notes": null},
        {"topic_code": "GRI 403", "score": 80.0, "completeness": 1, "notes": null},
        {"topic_code": "GRI 404", "score": 89.1, "completeness": 1, "notes": null},
        {"topic_code": "GRI 405", "score": 69.4, "completeness": 1, "notes": null},
        {"topic_code": "GRI 205", "score": 100.0, "completeness": 1, "notes": null},
        {"topic_code": "GRI 308/414", "score": 82.6, "completeness": 1, "notes": null},
        {"topic_code": "GRI 418/419", "score": 100.0, "completeness": 1, "notes": null},
        {"topic_code": "GRI 2", "score": 30.7, "completeness": 0, "notes": null}
      ],
      "sdg_scores": [
        {"sdg": 3, "score": 80.0, "material_topics_contributing": ["GRI 403"]},
        {"sdg": 4, "score": 89.1, "material_topics_contributing": ["GRI 404"]},
        {"sdg": 5, "score": 69.4, "material_topics_contributing": ["GRI 405"]},
        {"sdg": 6, "score": 81.5, "material_topics_contributing": ["GRI 303"]},
        {"sdg": 7, "score": 80.0, "material_topics_contributing": ["GRI 305", "GRI 302"]},
        {"sdg": 8, "score": 83.9, "material_topics_contributing": ["GRI 403", "GRI 404", "GRI 308/414"]},
        {"sdg": 10, "score": 69.4, "material_topics_contributing": ["GRI 405"]},
        {"sdg": 12, "score": 86.8, "material_topics_contributing": ["GRI 306", "GRI 308/414"]},
        {"sdg": 13, "score": 83.3, "material_topics_contributing": ["GRI 305"]},
        {"sdg": 16, "score": 100.0, "material_topics_contributing": ["GRI 205", "GRI 418/419"]}
      ],
      "overall_score": 81.7,
      "content_index": [],
      "qa": {
        "completeness_pct": 90.9,
        "has_external_assurance": true,
        "statement_of_use": "GRI Standards (in accordance)"
      }
    },
    "created_at": {"{\$date": "2025-11-08T12:16:45.142Z"},
    "updated_at": {"{\$date": "2025-11-08T12:16:45.142Z"}
  };

  @override
  Future<List<CompanyESGData>> getCompanies() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final company = CompanyESGData.fromJson(_mockCompanyData);
      return [company];
    } catch (e) {
      print('Error parsing mock data: $e');
      return [];
    }
  }

  @override
  Future<CompanyESGData?> getCompanyById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return CompanyESGData.fromJson(_mockCompanyData);
    } catch (e) {
      print('Error parsing mock data: $e');
      return null;
    }
  }

  @override
  Future<CompanyESGData?> getCompanyByCode(String companyCode) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return CompanyESGData.fromJson(_mockCompanyData);
    } catch (e) {
      print('Error parsing mock data: $e');
      return null;
    }
  }

  @override
  Future<ESGSummaryStats> getSummaryStats() async {
    await Future.delayed(const Duration(seconds: 1));
    return ESGSummaryStats(
      totalCompanies: 1,
      averageOverallScore: 81.7,
      companiesWithAssurance: 1,
      averageCompleteness: 90.9,
    );
  }
}
