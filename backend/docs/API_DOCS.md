# ESG Sustainability Report Backend

A Node.js + TypeScript backend for managing and computing ESG (Environmental, Social, Governance) sustainability reports aligned with GRI Standards.

## Features

- 🌱 **ESG Data Processing**: Automatically computes sustainability scores from company data
- 📊 **GRI Standards Aligned**: Supports GRI topic-based reporting framework
- 🎯 **SDG Mapping**: Links material topics to UN Sustainable Development Goals
- 🔄 **Auto-Computation**: POST company data and get computed report automatically
- 📈 **Scoring Engine**: Calculates topic scores, overall scores, and completeness metrics
- 🗄️ **MongoDB Storage**: Persists company data with embedded computed reports

## Quick Start

### Prerequisites

- Node.js (v16+)
- MongoDB (local or Atlas)
- pnpm (or npm/yarn)

### Installation

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env
# Edit .env with your MongoDB URI
```

### Environment Variables

Create a `.env` file:

```env
PORT=420
MONGO_URI=mongodb://localhost:27017
DB_NAME=esg_db
```

### Run the Server

```bash
# Development mode with auto-reload
pnpm dev

# Production build
pnpm build
pnpm start
```

### Seed Sample Data

```bash
# Populate database with 3 sample companies
pnpm seed
```

This creates:
- **DemoCo** - Original demo company with good ESG performance
- **GreenTech Solutions** - Excellent environmental scores
- **TechCorp Italia** - Mid-range performance across all topics

## API Documentation

### Base URL
```
http://localhost:420/api
```

### Endpoints

#### 1. Get All Companies
```http
GET /api/companies
```

**Response:**
```json
[
  {
    "_id": "507f1f77bcf86cd799439011",
    "report_metadata": { ... },
    "company_profile": { ... },
    "topics": { ... },
    "report": {
      "overall_score": 82.5,
      "topic_scores": [ ... ],
      "sdg_scores": [ ... ]
    },
    "created_at": "2024-01-15T10:00:00.000Z"
  }
]
```

#### 2. Get Company by ID
```http
GET /api/companies/:id
```

**Parameters:**
- `id` - MongoDB ObjectId

#### 3. Get Company by Company Code
```http
GET /api/companies/by-code/:companyId
```

**Parameters:**
- `companyId` - Company identifier from metadata (e.g., "IT-DEMOCO-2024")

#### 4. Create Company & Compute Report
```http
POST /api/companies
```

**Body:** Complete company ESG data (see schema below)

**What Happens:**
1. Receives company ESG input data
2. Validates required fields
3. **Automatically computes** sustainability scores using GRI-aligned scoring engine
4. Stores company data with embedded computed report
5. Returns complete document with scores

**Example Request:**
```json
{
  "report_metadata": {
    "report_id": "ESG-2024-DEMO-001",
    "company_id": "IT-MYCOMPANY-2024",
    "report_date": "2024-12-31",
    "reporting_period": {
      "start_date": "2024-01-01",
      "end_date": "2024-12-31",
      "fiscal_year": 2024,
      "currency": "EUR"
    },
    "statement_of_use": { ... }
  },
  "company_profile": {
    "basic_information": { ... },
    "financial_metrics": { ... },
    "workforce_profile": { ... }
  },
  "materiality": {
    "material_topics": [ ... ]
  },
  "topics": {
    "environmental": {
      "energy_climate": { ... },
      "water": { ... },
      "waste": { ... }
    },
    "social": { ... },
    "governance": { ... }
  }
}
```

**Response:**
```json
{
  "_id": "...",
  "report_metadata": { ... },
  "company_profile": { ... },
  "topics": { ... },
  "report": {
    "report_ref": {
      "report_id": "ESG-2024-DEMO-001",
      "company_id": "IT-MYCOMPANY-2024",
      "fiscal_year": 2024
    },
    "overall_score": 78.3,
    "topic_scores": [
      {
        "topic_code": "GRI 302",
        "score": 85.2,
        "completeness": 1.0
      },
      {
        "topic_code": "GRI 305",
        "score": 82.1,
        "completeness": 0.75
      }
      // ... more topics
    ],
    "sdg_scores": [
      {
        "sdg": 7,
        "score": 83.5,
        "material_topics_contributing": ["GRI 302", "GRI 305"]
      }
      // ... more SDGs
    ],
    "content_index": [ ... ],
    "qa": {
      "completeness_pct": 87.5,
      "has_external_assurance": true,
      "statement_of_use": "GRI Standards (in accordance)"
    }
  }
}
```

#### 5. Update Company & Recompute Report
```http
PUT /api/companies/:id
```

**Body:** Updated company ESG data

Automatically recomputes the report with new data.

#### 6. Get Only the Computed Report
```http
GET /api/companies/:id/report
```

Returns only the computed report section without input data.

#### 7. Delete Company
```http
DELETE /api/companies/:id
```

#### 8. Get Summary Statistics
```http
GET /api/stats/summary
```

**Response:**
```json
{
  "total_companies": 3,
  "average_overall_score": 76.8,
  "companies_with_assurance": 2,
  "average_completeness": 85.3
}
```

## Data Schema

### Input Schema: CompanyESGData

The input follows GRI Standards structure:

```typescript
{
  report_metadata: {
    report_id: string
    company_id: string
    report_date: string
    reporting_period: {
      fiscal_year: number
      currency: string
    }
    statement_of_use: {
      framework: "GRI Standards"
      claim: "in accordance" | "with reference"
      external_assurance?: {...}
    }
  }
  
  company_profile: {
    basic_information: {...}
    financial_metrics: {
      annual_revenue: number
      // ...
    }
    workforce_profile: {
      total_employees: number
      // ...
    }
  }
  
  materiality: {
    material_topics: [
      {
        topic_code: "GRI 305"  // Emissions
        topic_name: "Emissions"
        gri_disclosures: ["305-1", "305-2", "305-3"]
        sdg_links: [{sdg: 13, targets: ["13.2"]}]
      }
    ]
  }
  
  topics: {
    environmental: {
      energy_climate: {
        gri_mapping: ["302-1", "305-1", ...]
        metrics: {
          renewable_energy_pct: 70
          scope1_tco2e: 1100
          emissions_intensity_tco2e_per_m_eur: 38
          // ...
        }
      }
      water: {...}
      waste: {...}
    }
    social: {
      workforce: {...}
      health_safety: {...}
      training: {...}
    }
    governance: {
      ethics_anticorruption: {...}
      data_privacy_security: {...}
      board_governance: {...}
      supply_chain: {...}
    }
  }
}
```

### Output Schema: ComputedReport

```typescript
{
  report_ref: {
    report_id: string
    company_id: string
    fiscal_year: number
  }
  
  overall_score: number  // 0-100
  
  topic_scores: [
    {
      topic_code: "GRI 305"
      score: 82.5  // 0-100
      completeness: 0.75  // 0-1
      notes?: string[]
    }
  ]
  
  sdg_scores: [
    {
      sdg: 13  // SDG number
      score: 83.5
      material_topics_contributing: ["GRI 305", "GRI 302"]
    }
  ]
  
  content_index: [
    {
      standard: "GRI 305"
      disclosure_code: "305-1"
      disclosure_title: "Disclosure 305-1"
      location: "/disclosures/GRI 305/305-1"
    }
  ]
  
  qa: {
    completeness_pct: 87.5
    has_external_assurance: true
    statement_of_use: "GRI Standards (in accordance)"
  }
}
```

## Scoring Methodology

The scoring engine evaluates companies across 11 GRI topic areas:

### Environmental (E)
- **GRI 302** - Energy: Renewable %, intensity, year-over-year trends
- **GRI 305** - Emissions: Scope 1/2/3, intensity, reduction efforts
- **GRI 303** - Water: Consumption, recycling, water-stressed areas
- **GRI 306** - Waste: Recycling rate, hazardous waste management

### Social (S)
- **GRI 403** - Health & Safety: TRIR, LTIR, fatalities
- **GRI 404** - Training: Hours per employee, performance reviews
- **GRI 405** - Diversity: Gender diversity, pay equity

### Governance (G)
- **GRI 205** - Anti-corruption: Training coverage, incidents
- **GRI 418/419** - Privacy & Compliance: Data breaches, certifications
- **GRI 2** - Board Governance: Independence, diversity, attendance
- **GRI 308/414** - Supply Chain: ESG assessments, Code of Conduct

### Score Calculation

Each topic score = **40% completeness** + **60% performance**

- **Completeness**: % of expected GRI disclosures provided
- **Performance**: Metric-based scoring (industry benchmarks)

**Overall Score**: Weighted average of topic scores, emphasizing emissions and climate action.

## Frontend Integration

This backend is designed for a demo ESG dashboard app. Suggested features:

### Dashboard Views
```javascript
// Fetch all companies for comparison
const companies = await fetch('/api/companies').then(r => r.json());

// Show company sustainability report
const company = await fetch('/api/companies/by-code/IT-DEMOCO-2024')
  .then(r => r.json());

// Display:
// - Overall score gauge
// - Topic scores radar chart
// - SDG alignment visualization
// - Trend charts (if multi-year data)
// - Completeness metrics
```

### Example Charts
- **Overall Score Gauge**: `company.report.overall_score`
- **Topic Radar Chart**: `company.report.topic_scores`
- **SDG Bar Chart**: `company.report.sdg_scores`
- **E/S/G Breakdown**: Aggregate topic scores by category

## File Structure

```
backend/
├── src/
│   ├── server.ts              # Express server & API routes
│   ├── seed.ts                # Database seeding script
│   ├── types/
│   │   └── esg.types.ts       # TypeScript type definitions
│   └── services/
│       └── compute.service.ts # ESG scoring engine
├── examples/
│   ├── company_data.json      # Sample input data
│   └── compute.ts             # Original compute logic reference
├── package.json
└── tsconfig.json
```

## Development

### Add New Company
```bash
curl -X POST http://localhost:420/api/companies \
  -H "Content-Type: application/json" \
  -d @examples/company_data.json
```

### Test Endpoints
```bash
# Get all companies
curl http://localhost:420/api/companies

# Get specific company report
curl http://localhost:420/api/companies/:id/report

# Get stats
curl http://localhost:420/api/stats/summary
```

## License

ISC

## Notes

- All scores are on a 0-100 scale
- Completeness is 0-1 (converted to % for display)
- The scoring algorithm is illustrative for demo purposes
- For production, customize weights and benchmarks to your industry
