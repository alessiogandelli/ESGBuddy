// ESG Data Types - Input and Output Schemas

export type ReportingPeriod = {
  start_date: string;
  end_date: string;
  fiscal_year: number;
  currency: string;
};

export type ExternalAssurance = {
  assured: boolean;
  assurance_provider?: string;
  assurance_standard?: string;
  assurance_scope?: string;
  assurance_conclusion?: string;
};

export type StatementOfUse = {
  framework: "GRI Standards";
  claim: "in accordance" | "with reference";
  universal_standards: {
    gri_1: string;
    gri_2: string;
    gri_3: string;
  };
  topic_standards_used: string[];
  sector_standards_used: string[];
  external_assurance?: ExternalAssurance;
};

export type ReportingBoundary = {
  entities_included: string[];
  approach: string;
  exclusions: string[];
  changes_since_prior_period: string;
};

export type ReportMetadata = {
  report_id: string;
  company_id: string;
  report_date: string;
  reporting_period: ReportingPeriod;
  statement_of_use: StatementOfUse;
  reporting_boundary: ReportingBoundary;
};

export type BasicInformation = {
  legal_name: string;
  trade_name: string;
  headquarters: {
    address: string;
    country: string;
    region: string;
  };
  industry: {
    sector: string;
    subsector: string;
    gics_code: string;
    nace_code: string;
  };
  company_type: string;
  year_founded: number;
  website: string;
};

export type FinancialMetrics = {
  currency: string;
  annual_revenue: number;
  ebitda: number;
  total_assets: number;
  rd_investment: number;
  capex: number;
  sustainability_investment: number;
};

export type WorkforceProfile = {
  total_employees: number;
  total_fte: number;
  employees_by_contract: { permanent: number; temporary: number };
  employees_by_type: { full_time: number; part_time: number };
  contractors_non_employees: number;
  geographic_distribution: { [key: string]: number };
};

export type CompanyProfile = {
  basic_information: BasicInformation;
  financial_metrics: FinancialMetrics;
  workforce_profile: WorkforceProfile;
};

export type StakeholderEngagement = {
  stakeholder_group: string;
  engagement_method: string;
  key_issues: string[];
};

export type MaterialTopic = {
  topic_code: string;
  topic_name: string;
  boundary: string;
  sdg_links: { sdg: number; targets: string[] }[];
  gri_disclosures: string[];
};

export type Materiality = {
  stakeholder_engagement: StakeholderEngagement[];
  methodology: string;
  material_topics: MaterialTopic[];
};

export type TopicBlock = {
  gri_mapping: string[];
  sdg_mapping: string[];
  metrics: Record<string, number | string | boolean>;
  targets?: Record<string, number | string | boolean>;
};

export type EnvironmentalTopics = {
  energy_climate: TopicBlock;
  water: TopicBlock;
  waste: TopicBlock;
  materials?: TopicBlock;
};

export type SocialTopics = {
  workforce: TopicBlock;
  health_safety: TopicBlock;
  training: TopicBlock;
  diversity_equity?: TopicBlock;
};

export type GovernanceTopics = {
  ethics_anticorruption: TopicBlock;
  data_privacy_security: TopicBlock;
  board_governance: TopicBlock;
  supply_chain: TopicBlock;
};

export type Topics = {
  environmental: EnvironmentalTopics;
  social: SocialTopics;
  governance: GovernanceTopics;
};

// Main Input Type
export interface CompanyESGData {
  report_metadata: ReportMetadata;
  company_profile: CompanyProfile;
  materiality: Materiality;
  topics: Topics;
}

// Output Types
export type TopicScore = {
  topic_code: string;
  score: number;
  completeness: number;
  notes?: string[];
};

export type SDGScore = {
  sdg: number;
  score: number;
  material_topics_contributing: string[];
};

export type ContentIndexRow = {
  standard: string;
  disclosure_code: string;
  disclosure_title: string;
  location: string;
  omissions?: string;
};

export type QAMetrics = {
  completeness_pct: number;
  has_external_assurance: boolean;
  statement_of_use: string;
};

export interface ComputedReport {
  report_ref: {
    report_id: string;
    company_id: string;
    fiscal_year: number;
  };
  topic_scores: TopicScore[];
  sdg_scores: SDGScore[];
  overall_score: number;
  content_index: ContentIndexRow[];
  qa: QAMetrics;
}

// Database Document Type (combines input data + computed report)
export interface CompanyDocument extends CompanyESGData {
  _id?: any; // MongoDB ObjectId
  report?: ComputedReport;
  created_at?: Date;
  updated_at?: Date;
}
