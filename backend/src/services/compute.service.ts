import {
  CompanyESGData,
  ComputedReport,
  TopicScore,
  SDGScore,
  ContentIndexRow,
  MaterialTopic,
  TopicBlock
} from '../types/esg.types';

// Helper functions
const clamp = (v: number, min = 0, max = 100) => Math.max(min, Math.min(max, v));
const nz = (v: unknown, d = 0) => (typeof v === "number" ? v : d);
const bool1 = (v: unknown) => (v === true ? 1 : 0);

// Completeness calculation
function completenessFromMappings(found: string[], expected: string[]): number {
  if (!expected || expected.length === 0) return 1;
  const setFound = new Set(found.map((s) => s.trim()));
  const hit = expected.filter((e) => setFound.has(e.trim())).length;
  return hit / expected.length;
}

// Topic scoring functions
function scoreEnergyClimate(t: TopicBlock, revenueMEUR: number): number {
  const renPct = nz(t.metrics["renewable_energy_pct"]);
  const eInt = nz(t.metrics["energy_intensity_kwh_per_eur_revenue"]);
  const eTrend = -nz(t.metrics["yoy_energy_intensity_change_pct"]);
  const eIntScore = clamp(80 - 800 * eInt);
  const renScore = clamp(renPct);
  const trendScore = clamp(50 + eTrend);
  return clamp(0.4 * eIntScore + 0.4 * renScore + 0.2 * trendScore);
}

function scoreEmissions(t: TopicBlock, revenueMEUR: number): number {
  const emInt = nz(t.metrics["emissions_intensity_tco2e_per_m_eur"]);
  const emTrend = -nz(t.metrics["yoy_emissions_intensity_change_pct"]);
  const intensityScore = clamp(90 - 1.2 * emInt);
  const trendScore = clamp(50 + emTrend);
  return clamp(0.7 * intensityScore + 0.3 * trendScore);
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
  const sHrs = clamp(Math.min(100, 3 * avgHrs));
  const sRev = clamp(reviewed);
  return clamp(0.7 * sHrs + 0.3 * sRev);
}

function scoreDiversityEquity(workforce: TopicBlock, de: TopicBlock | undefined): number {
  const womenMgmt = nz(workforce.metrics["women_in_management"]);
  const total = nz(workforce.metrics["total_headcount"]);
  const womenMgmtPct = total > 0 ? (100 * womenMgmt) / Math.max(1, womenMgmt + (total - womenMgmt)) : 0;
  const payGap = de ? nz(de.metrics["gender_pay_gap_pct"]) : 5;
  const sMgmt = clamp(2.5 * womenMgmtPct);
  const sPay = clamp(100 - 3 * Math.abs(payGap));
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

// Content index generation
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

// SDG aggregation
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
  
  return Array.from(sdgMap.entries())
    .map(([sdg, v]) => ({
      sdg,
      score: v.weight > 0 ? Math.round((v.sum / v.weight) * 10) / 10 : 0,
      material_topics_contributing: Array.from(v.topics)
    }))
    .sort((a, b) => a.sdg - b.sdg);
}

// Main compute function
export function computeScores(input: CompanyESGData): ComputedReport {
  const revenue = input.company_profile?.financial_metrics?.annual_revenue ?? 0;
  const revenueMEUR = revenue / 1_000_000;
  const headcount = input.company_profile?.workforce_profile?.total_employees ?? 0;
  const mt = input.materiality.material_topics;

  // Expected disclosures per topic
  const expectedByTopic = new Map<string, string[]>(
    mt.map((m) => [m.topic_code, m.gri_disclosures])
  );

  // Find disclosed mappings
  function getFound(topicCode: string): string[] {
    const allBlocks: TopicBlock[] = [
      input.topics.environmental.energy_climate,
      input.topics.environmental.water,
      input.topics.environmental.waste,
      input.topics.environmental.materials,
      input.topics.social.workforce,
      input.topics.social.health_safety,
      input.topics.social.training,
      input.topics.social.diversity_equity,
      input.topics.governance.ethics_anticorruption,
      input.topics.governance.data_privacy_security,
      input.topics.governance.board_governance,
      input.topics.governance.supply_chain
    ].filter(Boolean) as TopicBlock[];

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
    topicScores.push({
      topic_code,
      score: Math.round(score * 10) / 10,
      completeness: Math.round(completeness * 100) / 100,
      notes: notes.length > 0 ? notes : undefined
    });
  }

  // Score each topic
  const topics = [
    { code: "GRI 302", expected: ["302-1","302-3","302-4"], scorer: () => scoreEnergyClimate(input.topics.environmental.energy_climate, revenueMEUR) },
    { code: "GRI 305", expected: ["305-1","305-2","305-3","305-5"], scorer: () => scoreEmissions(input.topics.environmental.energy_climate, revenueMEUR) },
    { code: "GRI 303", expected: ["303-3","303-4","303-5"], scorer: () => scoreWater(input.topics.environmental.water) },
    { code: "GRI 306", expected: ["306-3","306-4","306-5"], scorer: () => scoreWaste(input.topics.environmental.waste) },
    { code: "GRI 403", expected: ["403-1","403-2","403-9"], scorer: () => scoreHS(input.topics.social.health_safety) },
    { code: "GRI 404", expected: ["404-1","404-2","404-3"], scorer: () => scoreTraining(input.topics.social.training, headcount) },
    { code: "GRI 405", expected: ["405-1","405-2"], scorer: () => scoreDiversityEquity(input.topics.social.workforce, input.topics.social.diversity_equity) },
    { code: "GRI 205", expected: ["205-1","205-2","205-3"], scorer: () => scoreEthics(input.topics.governance.ethics_anticorruption) },
    { code: "GRI 308/414", expected: ["308-1","414-1","414-2"], scorer: () => scoreSupply(input.topics.governance.supply_chain) },
    { code: "GRI 418/419", expected: ["418-1","419-1"], scorer: () => scorePrivacy(input.topics.governance.data_privacy_security) },
    { code: "GRI 2", expected: ["2-9","2-10","2-11","2-12"], scorer: () => scoreBoard(input.topics.governance.board_governance) }
  ];

  for (const topic of topics) {
    const expected = expectedByTopic.get(topic.code) || topic.expected;
    const found = getFound(topic.code);
    const c = completenessFromMappings(found, expected);
    const perf = topic.scorer();
    pushScore(topic.code, c, perf);
  }

  // SDG scores
  const sdgScores = aggregateSDG(mt, topicScores);

  // Overall score
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

  // Content index
  const ci = contentIndex(mt, "/disclosures");

  // QA metrics
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
