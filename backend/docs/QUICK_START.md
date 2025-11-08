# ESG Sustainability Backend - Quick Reference

## 🚀 What I Built For You

A complete backend system for your ESG sustainability hackathon demo that:

1. **Accepts company ESG data** via POST request
2. **Automatically computes sustainability scores** using GRI-aligned algorithms
3. **Stores everything in MongoDB** with computed reports embedded
4. **Provides REST API** for your frontend to display reports and charts

## 📁 Files Created

### Core Backend
- **`src/server.ts`** - Express server with all API endpoints
- **`src/types/esg.types.ts`** - TypeScript schemas for input/output data
- **`src/services/compute.service.ts`** - ESG scoring engine (from your compute.ts)
- **`src/seed.ts`** - Database seeding script with 3 sample companies

### Documentation
- **`API_DOCS.md`** - Complete API documentation with examples

## 🎯 Key Endpoints

```bash
# Get all companies with reports
GET /api/companies

# Get specific company
GET /api/companies/:id
GET /api/companies/by-code/IT-DEMOCO-2024

# Create company (auto-computes report)
POST /api/companies
# Body: company ESG data

# Get just the computed report
GET /api/companies/:id/report

# Summary statistics
GET /api/stats/summary
```

## 📊 Data Flow

```
1. POST company data → /api/companies
                ↓
2. Server runs computeScores()
                ↓
3. Generates report with:
   - Overall score (0-100)
   - Topic scores (11 GRI topics)
   - SDG scores (linked to material topics)
   - Completeness metrics
   - Content index
                ↓
4. Stores in MongoDB as single document:
   {
     ...company_data,
     report: { ...computed_scores }
   }
                ↓
5. Returns complete document to client
```

## 🎨 Sample Companies (from seed script)

1. **DemoCo** (IT-DEMOCO-2024)
   - Original company from your example
   - Good overall performance
   
2. **GreenTech Solutions** (IT-GREENTECH-2024)
   - Excellent environmental scores
   - 95% renewable energy
   - Low emissions intensity
   
3. **TechCorp Italia** (IT-TECHCORP-2024)
   - Mid-range performance
   - No external assurance
   - Lower training hours

## 🚀 How to Use

### 1. Start MongoDB
```bash
# Local MongoDB
mongod

# Or use MongoDB Atlas (update .env)
```

### 2. Configure Environment
```bash
# Create .env file
PORT=420
MONGO_URI=mongodb://localhost:27017
DB_NAME=esg_db
```

### 3. Seed Database
```bash
pnpm seed
```

This populates 3 companies with computed reports.

### 4. Start Server
```bash
pnpm dev
```

### 5. Test API
```bash
# Get all companies
curl http://localhost:420/api/companies

# View in browser
open http://localhost:420/api/companies
```

## 🎨 Frontend Integration Ideas

### Dashboard Components

**1. Company Overview Card**
```javascript
const company = await fetch('/api/companies/by-code/IT-DEMOCO-2024')
  .then(r => r.json());

// Display:
- company.company_profile.basic_information.trade_name
- company.report.overall_score (as gauge/progress bar)
- company.report.qa.completeness_pct
```

**2. Topic Scores Radar Chart**
```javascript
const topicScores = company.report.topic_scores.map(t => ({
  topic: t.topic_code,
  score: t.score
}));

// Use in Chart.js/Recharts radar chart
// Categories: GRI 302 (Energy), GRI 305 (Emissions), etc.
```

**3. SDG Alignment**
```javascript
const sdgScores = company.report.sdg_scores;

// Show SDG icons with scores
// SDG 7 (Affordable Energy): 85.2
// SDG 13 (Climate Action): 82.1
```

**4. E-S-G Breakdown**
```javascript
// Aggregate scores by category
const envScores = topicScores.filter(t => 
  ['GRI 302', 'GRI 305', 'GRI 303', 'GRI 306'].includes(t.topic_code)
);
const avgEnv = envScores.reduce((sum, t) => sum + t.score, 0) / envScores.length;

// Similarly for Social and Governance
```

**5. Company Comparison**
```javascript
const companies = await fetch('/api/companies').then(r => r.json());

// Create comparison table/chart
companies.map(c => ({
  name: c.company_profile.basic_information.trade_name,
  overall: c.report.overall_score,
  env: c.report.topic_scores.filter(...).avgScore,
  social: ...,
  governance: ...
}))
```

## 📈 Scoring Logic Summary

- **11 GRI Topics** scored individually (0-100)
- **Score = 40% completeness + 60% performance**
- **Completeness**: % of expected GRI disclosures provided
- **Performance**: Metric-based (e.g., renewable %, emissions intensity)
- **Overall Score**: Weighted average (emissions weighted higher)

### Topic Categories:

**Environmental (E)**
- GRI 302: Energy
- GRI 305: Emissions
- GRI 303: Water
- GRI 306: Waste

**Social (S)**
- GRI 403: Health & Safety
- GRI 404: Training
- GRI 405: Diversity

**Governance (G)**
- GRI 205: Anti-corruption
- GRI 418/419: Privacy & Compliance
- GRI 2: Board Governance
- GRI 308/414: Supply Chain

## 🔧 Customization Options

### Add More Companies
```bash
# Edit src/seed.ts and add more company variations
# Then run: pnpm seed
```

### Adjust Scoring Weights
```bash
# Edit src/services/compute.service.ts
# Modify the weights Map in computeScores()
```

### Add New Endpoints
```bash
# Edit src/server.ts
# Example: GET /api/companies/:id/trends
```

## 📝 Next Steps for Your Demo

1. **Build Frontend Dashboard**
   - Fetch companies from API
   - Display scores with charts
   - Show ESG metrics breakdown
   
2. **Add Visualizations**
   - Gauge charts for overall scores
   - Radar charts for topic scores
   - SDG alignment matrix
   - Trend lines (if multi-year data)
   
3. **Interactive Features**
   - Filter/sort companies
   - Compare 2-3 companies side-by-side
   - Drill down into specific topics
   - View GRI disclosure details

4. **Data Entry Form** (Optional)
   - Let users input their own company data
   - POST to /api/companies
   - Show instant computed report

## 🎯 Demo Flow Suggestion

1. **Landing**: Show all 3 companies with overall scores
2. **Company Detail**: Click a company → full report view
3. **Charts Tab**: Visual breakdown of E-S-G scores
4. **SDG Tab**: Show contribution to UN goals
5. **Comparison Tab**: Compare all companies side-by-side

## 🐛 Troubleshooting

**MongoDB connection error?**
- Check MongoDB is running: `mongod`
- Verify MONGO_URI in .env

**TypeScript errors?**
- Run: `pnpm build`
- Check src/types/esg.types.ts

**No data returned?**
- Run seed script: `pnpm seed`
- Check collection: Use MongoDB Compass

## 📚 Resources

- **API Docs**: See `API_DOCS.md` for detailed endpoint documentation
- **Sample Data**: `examples/company_data.json`
- **Types Reference**: `src/types/esg.types.ts`

---

**Ready to go!** Start the server with `pnpm dev` and your backend will serve ESG reports at `http://localhost:420` 🚀
