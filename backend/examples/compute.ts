// compute.ts
// Minimal scoring engine for GRI/SDG-aligned demo pipelines

type Numeric = number;
type YesNo = boolean;

// ---------- Types (trimmed for brevity) ----------
type ReportingPeriod = { start_date: string; end_date: string; fiscal_year: number; currency: string };
type StatementOfUse = {
  framework: "GRI Standards";
  claim: "in accordance" | "with reference";
  universal_standards: { gri_1: string; gri_2: string; gri_3: string };
  topic_standards_used: string[];
  sector_standards_used: string[];
  external_assurance?: {
    assured: boolean;
    assurance_provider?: string;
    assurance_standard?: string;
    assurance_scope?: string;
    assurance_conclusion?: string;
  };
};
type ReportMetadata = {
  report_id: string;
  company_id: string;
  report_date: string;
  reporting_period: ReportingPeriod;
  statement_of_use: StatementOfUse;
  reporting_boundary: {
    entities_included: string[];
    approach: string;
    exclusions: string[];
    changes_since_prior_period: string;
  };
};

type MaterialTopic = {
  topic_code: string;
  topic_name: string;
  boundary: string;
  sdg_links: { sdg: number; targets: string[] }[];
  gri_disclosures: string[];
};

type TopicBlock = {
  gri_mapping: string[];
  sdg_mapping: string[];
  metrics: Record<string, number | string | boolean>;
  targets?: Record<string, number | string | boolean>;
};

type InputJSON = {
  report_metadata: ReportMetadata;
  company_profile: any;
  materiality: {
    stakeholder_engagement: any[];
    methodology: string;
    material_topics: MaterialTopic[];
  };
  topics: {
    environmental: {
      energy_climate: TopicBlock;
      water: TopicBlock;
      waste: TopicBlock;
      materials?: TopicBlock;
    };
    social: {
      workforce: TopicBlock;
      health_safety: TopicBlock;
      training: TopicBlock;
      diversity_equity?: TopicBlock;
    };
    governance: {
      ethics_anticorruption: TopicBlock;
      data_privacy_security: TopicBlock;
      board_governance: TopicBlock;
      supply_chain: TopicBlock;
    };
  };
};

// ---------- Output Types ----------
type TopicScore = { topic_code: string; score: number; completeness: number; notes?: string[] };
type SDGScore = { sdg: number; score: number; material_topics_contributing: string[] };
type ContentIndexRow = { standard: string; disclosure_code: string; disclosure_title: string; location: string; omissions?: string };

type OutputJSON = {
  report_ref: { report_id: string; company_id: string; fiscal_year: number };
  topic_scores: TopicScore[];
  sdg_scores: SDGScore[];
  overall_score: number;
  content_index: ContentIndexRow[];
  qa: { completeness_pct: number; has_external_assurance: boolean; statement_of_use: string };
};

// ---------- Helpers ----------
const clamp = (v: number, min = 0, max = 100) => Math.max(min, Math.min(max, v));
const pct = (num: number, den: number) => (den > 0 ? (100 * num) / den : 0);
const nz = (v: unknown, d = 0) => (typeof v === "number" ? v : d);
const bool1 = (v: unknown) => (v === true ? 1 : 0);

// ---------- Completeness ----------
function completenessFromMappings(found: string[], expected: string[]): number {
  if (!expected || expected.length === 0) return 1;
  const setFound = new Set(found.map((s) => s.trim()));
  const hit = expected.filter((e) => setFound.has(e.trim())).length;
  return hit / expected.length;
}

// ---------- Topic scoring (illustrative demo logic) ----------
function scoreEnergyClimate(t: TopicBlock, revenueMEUR: number): number {
  const renPct = nz(t.metrics["renewable_energy_pct"]);
  const eInt = nz(t.metrics["energy_intensity_kwh_per_eur_revenue"]);
  const eTrend = -nz(t.metrics["yoy_energy_intensity_change_pct"]); // improvement positive
  const eIntScore = clamp(80 - 800 * eInt); // lower intensity -> higher score
  const renScore = clamp(renPct); // 0-100
  const trendScore = clamp(50 + eTrend); // small boost for improvement
  return clamp(0.4 * eIntScore + 0.4 * renScore + 0.2 * trendScore);
}

function scoreEmissions(t: TopicBlock, revenueMEUR: number): number {
  const emInt = nz(t.metrics["emissions_intensity_tco2e_per_m_eur"]);
  const emTrend = -nz(t.metrics["yoy_emissions_intensity_change_pct"]);
  const intensityScore = clamp(90 - 1.2 * emInt); // lower is better
  const trendScore = clamp(50 + emTrend);
  const s12 = clamp(0.7 * intensityScore + 0.3 * trendScore);
  return s12;
}

function scoreWater(t: TopicBlock): number {
  const wInt = nz(t.metrics["water_intensity_m3_per_eur_revenue"]);
  const wTrend = -nz(t.metrics["yoy_water_intensity_change_pct"]);
  const rec = nz(t.metrics["water_recycled_m3"]);
  const wScore = clamp(85 - 60000 * wInt);
  const trendScore = clamp(50 + wTrend);
  const recycleScore = clamp(rec > 0 ? 70 : 40);
  return clamp(0.5 * wScore + 0.3 * trendScore + 0.2 * recycleScore);
}

function scoreWaste(t: TopicBlock): number {
  const rr = nz(t.metrics["recycling_rate_pct"]);
  const haz = nz(t.metrics["hazardous_waste_t"]);
  const rrScore = clamp(rr);
  const hazScore = clamp(80 - 10 * haz);
  return clamp(0.8 * rrScore + 0.2 * hazScore);
}

function scoreHS(t: TopicBlock): number {
  const trir = nz(t.metrics["trir"]);
  const ltir = nz(t.metrics["ltir"]);
  const sTrir = clamp(90 - 30 * trir);
  const sLtir = clamp(95 - 50 * ltir);
  return clamp(0.6 * sTrir + 0.4 * sLtir);
}

function scoreTraining(t: TopicBlock, headcount: number): number {
  const avgHrs = nz(t.metrics["avg_training_hours_per_employee"]);
  const reviewed = nz(t.metrics["employees_reviewed_pct"]);
  const sHrs = clamp(Math.min(100, 3 * avgHrs)); // 33+ hrs ~ 100
  const sRev = clamp(reviewed);
  return clamp(0.7 * sHrs + 0.3 * sRev);
}

function scoreDiversityEquity(workforce: TopicBlock, de: TopicBlock | undefined): number {
  const womenMgmt = nz(workforce.metrics["women_in_management"]);
  const total = nz(workforce.metrics["total_headcount"]);
  const womenMgmtPct = total > 0 ? (100 * womenMgmt) / Math.max(1, womenMgmt + (total - womenMgmt)) : 0;
  const payGap = de ? nz(de.metrics["gender_pay_gap_pct"]) : 5;
  const sMgmt = clamp(2.5 * womenMgmtPct); // 40% -> 100
  const sPay = clamp(100 - 3 * Math.abs(payGap)); // 0% gap best
  return clamp(0.6 * sMgmt + 0.4 * sPay);
}

function scoreEthics(t: TopicBlock): number {
  const trained = nz(t.metrics["employees_trained_anti_corruption_pct"]);
  const incidents = nz(t.metrics["confirmed_corruption_incidents"]);
  const fines = nz(t.metrics["legal_fines_eur"]);
  const base = clamp(trained);
  const penalty = incidents > 0 || fines > 0 ? 30 : 0;
  return clamp(base - penalty);
}

function scorePrivacy(t: TopicBlock): number {
  const breaches = nz(t.metrics["data_breaches"]);
  const iso = bool1(t.metrics["iso_27001_certified"]) ? 10 : 0;
  const gdpr = bool1(t.metrics["gdpr_compliant"]) ? 10 : 0;
  const base = 80 + iso + gdpr;
  const penalty = breaches > 0 ? 50 : 0;
  return clamp(base - penalty);
}

function scoreBoard(t: TopicBlock): number {
  const indep = nz(t.metrics["independent_directors_pct"]);
  const women = nz(t.metrics["board_gender_diversity_women_pct"]);
  const attend = nz(t.metrics["avg_board_attendance_pct"]);
  return clamp(0.4 * indep + 0.4 * women + 0.2 * attend);
}

function scoreSupply(t: TopicBlock): number {
  const coc = nz(t.metrics["suppliers_signed_coc_pct"]);
  const audited = nz(t.metrics["suppliers_audited_esg_pct"]);
  const viol = nz(t.metrics["supplier_esg_violations"]);
  const remed = nz(t.metrics["supplier_esg_violations_remediated"]);
  const base = clamp(0.6 * coc + 0.4 * audited);
  const penalty = viol > 0 && remed === 0 ? 20 : 5;
  return clamp(base - penalty);
}

// ---------- Content index generation (demo) ----------
function contentIndex(material: MaterialTopic[], baseRoute = ""): ContentIndexRow[] {
  return material.flatMap((m) =>
    m.gri_disclosures.map((d) => ({
      standard: m.topic_code,
      disclosure_code: d,
      disclosure_title: "Disclosure " + d,
      location: `${baseRoute}/${m.topic_code}/${d}`
    }))
  );
}

// ---------- SDG aggregation ----------
function aggregateSDG(material: MaterialTopic[], topicScores: TopicScore[]): SDGScore[] {
  const byTopic = new Map(topicScores.map((t) => [t.topic_code, t.score]));
  const sdgMap = new Map<number, { sum: number; weight: number; topics: Set<string> }>();
  for (const m of material) {
    const s = byTopic.get(m.topic_code) ?? 0;
    for (const link of m.sdg_links) {
      const entry = sdgMap.get(link.sdg) ?? { sum: 0, weight: 0, topics: new Set<string>() };
      entry.sum += s;
      entry.weight += 1;
      entry.topics.add(m.topic_code);
      sdgMap.set(link.sdg, entry);
    }
  }
  return Array.from(sdgMap.entries()).map(([sdg, v]) => ({
    sdg,
    score: v.weight > 0 ? Math.round((v.sum / v.weight) * 10) / 10 : 0,
    material_topics_contributing: Array.from(v.topics)
  }));
}

// ---------- Main compute ----------
export function computeScores(input: InputJSON): OutputJSON {
  const fy = input.report_metadata.reporting_period.fiscal_year;
  const revenue = input.company_profile?.financial_metrics?.annual_revenue ?? 0;
  const revenueMEUR = revenue / 1_000_000;
  const headcount = input.company_profile?.workforce_profile?.total_employees ?? 0;
  const mt = input.materiality.material_topics;

  // Expected disclosures per topic from materiality (as declared)
  const expectedByTopic = new Map<string, string[]>(
    mt.map((m) => [m.topic_code, m.gri_disclosures])
  );

  // Found mappings by topic from the input topic blocks
  function getFound(topicCode: string): string[] {
    const allBlocks: TopicBlock[] = [
      input.topics.environmental.energy_climate,
      input.topics.environmental.water,
      input.topics.environmental.waste,
      input.topics.environmental.materials!,
      input.topics.social.workforce,
      input.topics.social.health_safety,
      input.topics.social.training,
      input.topics.social.diversity_equity!,
      input.topics.governance.ethics_anticorruption,
      input.topics.governance.data_privacy_security,
      input.topics.governance.board_governance,
      input.topics.governance.supply_chain
    ].filter(Boolean as any);

    // naive mapping: a block "belongs" if its gri_mapping contains codes present in expected list
    const expected = expectedByTopic.get(topicCode) || [];
    const found = new Set<string>();
    for (const b of allBlocks) {
      for (const code of b.gri_mapping) {
        if (expected.includes(code)) found.add(code);
      }
    }
    return Array.from(found);
  }

  // Compute topic scores
  const topicScores: TopicScore[] = [];
  function pushScore(topic_code: string, completeness: number, perf: number, notes: string[] = []) {
    const score = clamp(0.4 * Math.round(completeness * 1000) / 10 + 0.6 * perf);
    topicScores.push({ topic_code, score: Math.round(score * 10) / 10, completeness: Math.round(completeness * 100) / 100, notes });
  }

  // Energy (302)
  {
    const expected = expectedByTopic.get("GRI 302") || ["302-1","302-3","302-4"];
    const found = getFound("GRI 302");
    const c = completenessFromMappings(found, expected);
    const perf = scoreEnergyClimate(input.topics.environmental.energy_climate, revenueMEUR);
    pushScore("GRI 302", c, perf);
  }

  // Emissions (305)
  {
    const expected = expectedByTopic.get("GRI 305") || ["305-1","305-2","305-3","305-5"];
    const found = getFound("GRI 305");
    const c = completenessFromMappings(found, expected);
    const perf = scoreEmissions(input.topics.environmental.energy_climate, revenueMEUR);
    pushScore("GRI 305", c, perf);
  }

  // Water (303)
  {
    const expected = expectedByTopic.get("GRI 303") || ["303-3","303-4","303-5"];
    const found = getFound("GRI 303");
    const c = completenessFromMappings(found, expected);
    const perf = scoreWater(input.topics.environmental.water);
    pushScore("GRI 303", c, perf);
  }

  // Waste (306)
  {
    const expected = expectedByTopic.get("GRI 306") || ["306-3","306-4","306-5"];
    const found = getFound("GRI 306");
    const c = completenessFromMappings(found, expected);
    const perf = scoreWaste(input.topics.environmental.waste);
    pushScore("GRI 306", c, perf);
  }

  // H&S (403)
  {
    const expected = expectedByTopic.get("GRI 403") || ["403-1","403-2","403-9"];
    const found = getFound("GRI 403");
    const c = completenessFromMappings(found, expected);
    const perf = scoreHS(input.topics.social.health_safety);
    pushScore("GRI 403", c, perf);
  }

  // Training (404)
  {
    const expected = expectedByTopic.get("GRI 404") || ["404-1","404-2","404-3"];
    const found = getFound("GRI 404");
    const c = completenessFromMappings(found, expected);
    const perf = scoreTraining(input.topics.social.training, headcount);
    pushScore("GRI 404", c, perf);
  }

  // Diversity (405)
  {
    const expected = expectedByTopic.get("GRI 405") || ["405-1","405-2"];
    const found = getFound("GRI 405");
    const c = completenessFromMappings(found, expected);
    const perf = scoreDiversityEquity(input.topics.social.workforce, input.topics.social.diversity_equity);
    pushScore("GRI 405", c, perf);
  }

  // Anti-corruption (205)
  {
    const expected = expectedByTopic.get("GRI 205") || ["205-1","205-2","205-3"];
    const found = getFound("GRI 205");
    const c = completenessFromMappings(found, expected);
    const perf = scoreEthics(input.topics.governance.ethics_anticorruption);
    pushScore("GRI 205", c, perf);
  }

  // Supplier assessment (308/414)
  {
    const expected = expectedByTopic.get("GRI 308/414") || ["308-1","414-1","414-2"];
    const found = getFound("GRI 308/414");
    const c = completenessFromMappings(found, expected);
    const perf = scoreSupply(input.topics.governance.supply_chain);
    pushScore("GRI 308/414", c, perf);
  }

  // Privacy & compliance (418/419)
  {
    const expected = expectedByTopic.get("GRI 418/419") || ["418-1","419-1"];
    const found = getFound("GRI 418/419");
    const c = completenessFromMappings(found, expected);
    const perf = scorePrivacy(input.topics.governance.data_privacy_security);
    pushScore("GRI 418/419", c, perf);
  }

  // Board governance (GRI 2 related)
  {
    const expected = expectedByTopic.get("GRI 2") || ["2-9","2-10","2-11","2-12"];
    const found = getFound("GRI 2");
    const c = completenessFromMappings(found, expected);
    const perf = scoreBoard(input.topics.governance.board_governance);
    pushScore("GRI 2", c, perf);
  }

  // SDG aggregation from materiality links
  const sdgScores = aggregateSDG(mt, topicScores);

  // Overall score: weighted average with simple weights favoring core impacts
  const weights = new Map<string, number>([
    ["GRI 305", 1.2], ["GRI 302", 1.0], ["GRI 303", 0.8], ["GRI 306", 0.8],
    ["GRI 403", 1.0], ["GRI 404", 0.7], ["GRI 405", 0.9], ["GRI 205", 0.9],
    ["GRI 308/414", 0.8], ["GRI 418/419", 0.9], ["GRI 2", 0.6]
  ]);
  let sum = 0, wsum = 0;
  for (const t of topicScores) {
    const w = weights.get(t.topic_code) ?? 0.7;
    sum += t.score * w;
    wsum += w;
  }
  const overall = wsum > 0 ? Math.round((sum / wsum) * 10) / 10 : 0;

  // Content index from declared material topics/disclosures
  const ci = contentIndex(mt, "/disclosures");

  const qa = {
    completeness_pct: Math.round((topicScores.reduce((a, b) => a + b.completeness, 0) / topicScores.length) * 1000) / 10,
    has_external_assurance: input.report_metadata.statement_of_use.external_assurance?.assured === true,
    statement_of_use: `${input.report_metadata.statement_of_use.framework} (${input.report_metadata.statement_of_use.claim})`
  };

  return {
    report_ref: {
      report_id: input.report_metadata.report_id,
      company_id: input.report_metadata.company_id,
      fiscal_year: input.report_metadata.reporting_period.fiscal_year
    },
    topic_scores: topicScores,
    sdg_scores: sdgScores,
    overall_score: overall,
    content_index: ci,
    qa
  };
}

// Example CLI usage (ts-node):
// import fs from "fs";
// const input: InputJSON = JSON.parse(fs.readFileSync("company_data_input.json","utf-8"));
// const output = computeScores(input);
// fs.writeFileSync("computed_output.json", JSON.stringify(output, null, 2));
