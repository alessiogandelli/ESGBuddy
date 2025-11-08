# ESG Backend Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         Frontend App                             │
│                    (Your Demo Dashboard)                         │
│                                                                   │
│  Components:                                                      │
│  • Company List View                                             │
│  • Sustainability Report Detail                                  │
│  • ESG Score Charts (Radar, Gauge, Bar)                         │
│  • SDG Alignment Visualization                                   │
│  • Company Comparison Table                                      │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     │ REST API Calls
                     │
┌────────────────────▼────────────────────────────────────────────┐
│                     Express Backend                              │
│                   (Node.js + TypeScript)                         │
│                                                                   │
│  API Routes:                                                      │
│  GET  /api/companies                  - List all                │
│  POST /api/companies                  - Create + compute         │
│  GET  /api/companies/:id              - Get one                 │
│  GET  /api/companies/:id/report       - Get report only         │
│  GET  /api/stats/summary              - Statistics              │
│                                                                   │
│  ┌───────────────────────────────────────────────────────┐     │
│  │         Compute Service (compute.service.ts)           │     │
│  │                                                         │     │
│  │  computeScores(companyData) → ComputedReport           │     │
│  │                                                         │     │
│  │  • Calculates 11 GRI topic scores                      │     │
│  │  • Aggregates SDG alignment                            │     │
│  │  • Computes overall score (weighted avg)               │     │
│  │  • Generates content index                             │     │
│  │  • Assesses completeness                               │     │
│  └───────────────────────────────────────────────────────┘     │
│                                                                   │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     │ MongoDB Driver
                     │
┌────────────────────▼────────────────────────────────────────────┐
│                      MongoDB Database                            │
│                                                                   │
│  Collection: companies                                           │
│                                                                   │
│  Document Structure:                                             │
│  {                                                               │
│    _id: ObjectId,                                               │
│    report_metadata: { ... },     ← Input data                   │
│    company_profile: { ... },     ← Input data                   │
│    materiality: { ... },         ← Input data                   │
│    topics: {                     ← Input data                   │
│      environmental: { ... },                                     │
│      social: { ... },                                            │
│      governance: { ... }                                         │
│    },                                                            │
│    report: {                     ← ✨ COMPUTED                  │
│      overall_score: 82.5,                                        │
│      topic_scores: [...],                                        │
│      sdg_scores: [...],                                          │
│      content_index: [...],                                       │
│      qa: { ... }                                                 │
│    },                                                            │
│    created_at: Date,                                             │
│    updated_at: Date                                              │
│  }                                                               │
└──────────────────────────────────────────────────────────────────┘
```

## Data Flow: Creating a Company

```
1. Client sends POST request
   ↓
   {
     report_metadata: {...},
     company_profile: {...},
     topics: {
       environmental: {...},
       social: {...},
       governance: {...}
     }
   }

2. Server receives & validates
   ↓
   server.ts: POST /api/companies handler

3. Compute ESG scores
   ↓
   computeScores(companyData)
   ├─ Score Energy (GRI 302)
   ├─ Score Emissions (GRI 305)
   ├─ Score Water (GRI 303)
   ├─ Score Waste (GRI 306)
   ├─ Score Health & Safety (GRI 403)
   ├─ Score Training (GRI 404)
   ├─ Score Diversity (GRI 405)
   ├─ Score Ethics (GRI 205)
   ├─ Score Privacy (GRI 418/419)
   ├─ Score Board (GRI 2)
   └─ Score Supply Chain (GRI 308/414)
   ↓
   Aggregate to:
   - 11 topic scores
   - SDG scores (grouped by material topics)
   - Overall weighted score
   - Completeness percentage

4. Store in database
   ↓
   MongoDB.insert({
     ...companyData,
     report: computedReport
   })

5. Return to client
   ↓
   {
     _id: "...",
     ...companyData,
     report: {
       overall_score: 82.5,
       topic_scores: [...],
       sdg_scores: [...]
     }
   }
```

## Scoring Algorithm

```
For each GRI Topic:

┌─────────────────────────────────────────────┐
│          Topic Score Calculation             │
├─────────────────────────────────────────────┤
│                                              │
│  Completeness Score (0-1)                   │
│  ↓                                           │
│  Found GRI disclosures / Expected disclosures│
│  Example: 3/4 = 0.75 (75%)                   │
│                                              │
│  Performance Score (0-100)                   │
│  ↓                                           │
│  Based on metrics:                           │
│  • Energy: renewable %, intensity, trends    │
│  • Emissions: intensity, reduction targets   │
│  • H&S: TRIR, LTIR rates                    │
│  • Training: hours per employee              │
│  etc.                                        │
│                                              │
│  Final Topic Score                           │
│  ↓                                           │
│  (Completeness × 40) + (Performance × 0.6)  │
│                                              │
└─────────────────────────────────────────────┘

Overall Score:
  Weighted average of all topic scores
  (Emissions and climate weighted higher)
```

## GRI Topics → SDG Mapping

```
Material Topics define SDG links:

Example:
{
  topic_code: "GRI 305",
  topic_name: "Emissions",
  sdg_links: [
    { sdg: 7, targets: ["7.2", "7.3"] },
    { sdg: 13, targets: ["13.2"] }
  ]
}

Aggregation:
For each SDG, average the scores of all topics that contribute to it.

SDG 13 Score = avg(GRI 305 score, GRI 302 score, ...)
```

## File Organization

```
backend/
├── src/
│   ├── server.ts                    # 🚀 Main Express app
│   │   ├── Routes
│   │   ├── MongoDB connection
│   │   └── Request handlers
│   │
│   ├── services/
│   │   └── compute.service.ts       # 🧮 Scoring engine
│   │       ├── Topic scoring functions
│   │       ├── SDG aggregation
│   │       └── computeScores()
│   │
│   ├── types/
│   │   └── esg.types.ts            # 📋 TypeScript types
│   │       ├── CompanyESGData (input)
│   │       ├── ComputedReport (output)
│   │       └── CompanyDocument (DB)
│   │
│   └── seed.ts                      # 🌱 Sample data generator
│       └── Creates 3 demo companies
│
├── examples/
│   └── company_data.json            # 📊 Sample input
│
├── API_DOCS.md                      # 📖 Full API reference
├── QUICK_START.md                   # ⚡ Quick guide
└── package.json
```

## Sample Data: 3 Companies

```
┌──────────────────────────────────────────────────────────┐
│  DemoCo (IT-DEMOCO-2024)                                 │
│  ────────────────────────────────────────────────────    │
│  Overall Score: ~78-82                                   │
│  Renewable Energy: 70%                                   │
│  Training Hours: 28.9/employee                          │
│  External Assurance: Yes                                │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  GreenTech Solutions (IT-GREENTECH-2024)                │
│  ────────────────────────────────────────────────────    │
│  Overall Score: ~85-90 (Best performer)                 │
│  Renewable Energy: 95% ⚡                               │
│  Emissions Intensity: Very low                          │
│  Gender Diversity: High                                 │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│  TechCorp Italia (IT-TECHCORP-2024)                     │
│  ────────────────────────────────────────────────────    │
│  Overall Score: ~65-72 (Room for improvement)           │
│  Renewable Energy: 45%                                  │
│  Training: Lower hours                                  │
│  External Assurance: No                                 │
└──────────────────────────────────────────────────────────┘
```

## Frontend Integration Points

### 1. Dashboard Homepage
```javascript
GET /api/companies
→ Display cards for each company with overall score
```

### 2. Company Detail Page
```javascript
GET /api/companies/by-code/IT-DEMOCO-2024
→ Full report with all metrics
```

### 3. Charts & Visualizations

**Radar Chart (Topic Scores)**
```javascript
company.report.topic_scores.map(t => ({
  axis: t.topic_code,
  value: t.score
}))
```

**SDG Bar Chart**
```javascript
company.report.sdg_scores.map(s => ({
  sdg: s.sdg,
  score: s.score
}))
```

**Gauge/Progress for Overall Score**
```javascript
const score = company.report.overall_score; // 0-100
```

### 4. Comparison View
```javascript
GET /api/companies
→ Create comparison table with multiple companies
```

### 5. Statistics Dashboard
```javascript
GET /api/stats/summary
→ Show aggregate stats across all companies
```

---

**Built for your hackathon demo! 🚀**
