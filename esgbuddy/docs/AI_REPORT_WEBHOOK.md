# AI Improvement Report Webhook

## Overview
The Improve Screen includes an AI-powered analysis feature that generates natural language improvement reports based on complete company ESG data.

## Endpoint
```
POST https://00229abdafd2.ngrok-free.app/webhook-test/ai-insights
```

## Request Format

### Headers
```json
{
  "Content-Type": "application/json"
}
```

### Request Body
The webhook receives the **complete company ESG data** in JSON format:

```json
{
  "id": "673d8e4eb3f96b4bfa87f83c",
  "company_id": "IT-GREENTECH-2024",
  "report_id": "ESG-2024-DEMO-002",
  "fiscal_year": 2024,
  "basic_info": {
    "legal_name": "GreenTech Solutions S.p.A.",
    "trade_name": "GreenTech Solutions S.p.A.",
    "industry": "Technology",
    "sector": "Software & IT Services",
    "country": "Italy",
    "financial_metrics": {
      "currency": "EUR",
      "annual_revenue": 45000000,
      "ebitda": 12000000,
      "total_assets": 32000000,
      "rd_investment": 3500000,
      "capex": 2000000,
      "sustainability_investment": 1500000
    }
  },
  "report": {
    "overall_score": 82.1,
    "topic_scores": [
      {
        "topic_code": "GRI 302",
        "score": 77.2,
        "completeness": 1,
        "notes": null
      },
      {
        "topic_code": "GRI 305",
        "score": 83.3,
        "completeness": 1,
        "notes": null
      }
      // ... all topic scores
    ],
    "sdg_scores": [
      {
        "sdg": 3,
        "score": 80,
        "material_topics_contributing": ["GRI 403"]
      },
      {
        "sdg": 5,
        "score": 70.1,
        "material_topics_contributing": ["GRI 405"]
      }
      // ... all SDG scores
    ],
    "qa": {
      "completeness_pct": 85.5,
      "has_external_assurance": false,
      "statement_of_use": "GRI Standards 2021"
    }
  }
}
```

## Response Format

### Success Response (200)
**The response should be PLAIN TEXT**, not JSON:

```
Based on the ESG analysis for GreenTech Solutions S.p.A. (FY 2024), here are the key improvement areas:

**Priority 1: Gender Equality & Reduced Inequalities (SDG 5 & 10 - Score: 70.1/100)**
These are your most critical areas requiring immediate attention. With scores at 70.1, both areas are in the medium-performance range but lag behind your other metrics.

Key Issues:
- Gender diversity metrics (GRI 405) show room for improvement
- Pay equity and representation gaps need addressing

Recommendations:
1. Establish clear diversity targets with specific timelines
2. Implement unconscious bias training programs
3. Create mentorship programs for underrepresented groups
4. Conduct regular pay equity audits
5. Report progress transparently in your sustainability reports

**Priority 2: Good Health and Well-being (SDG 3 - Score: 80.0/100)**
You're performing well here, but there's still room to reach excellence.

Key Areas:
- Workplace health and safety (GRI 403) is solid but can be enhanced

Recommendations:
1. Expand mental health support programs
2. Increase focus on preventative health initiatives
3. Enhance work-life balance policies

**Overall Assessment:**
Your overall score of 82.1/100 is commendable, placing you in the 'good' performance category. The main opportunity lies in strengthening social equity measures, particularly around diversity and inclusion.
```

### Error Response (Non-200 status code)
Any non-200 status code will be treated as an error and shown to the user.

## n8n Workflow Setup

### Recommended Workflow Structure:

1. **Webhook Node** - Receive the POST request with complete company data
2. **Function Node** - Extract and format key metrics for AI prompt
3. **HTTP Request Node** - Call your AI service (OpenAI, Claude, Gemini, etc.)
4. **Respond to Webhook Node** - Return **PLAIN TEXT** (not JSON)

### Example AI Prompt Template:
```
You are an ESG (Environmental, Social, Governance) consultant analyzing company performance data.

Company: {{$json.basic_info.trade_name}}
Industry: {{$json.basic_info.industry}} - {{$json.basic_info.sector}}
Country: {{$json.basic_info.country}}
Overall ESG Score: {{$json.report.overall_score}}/100
Fiscal Year: {{$json.fiscal_year}}

Financial Context:
- Annual Revenue: €{{$json.basic_info.financial_metrics.annual_revenue}}
- Sustainability Investment: €{{$json.basic_info.financial_metrics.sustainability_investment}}

SDG Performance:
{{$json.report.sdg_scores}}

Topic Scores (GRI):
{{$json.report.topic_scores}}

Quality Assurance:
- Data Completeness: {{$json.report.qa.completeness_pct}}%
- External Assurance: {{$json.report.qa.has_external_assurance}}

Generate a comprehensive, actionable improvement report that:
1. Identifies the most problematic areas based on the scores
2. Explains why these scores are concerning in the context of their industry
3. Provides specific, actionable recommendations
4. Uses a professional but accessible tone
5. Prioritizes improvements by severity
6. References relevant GRI standards and SDGs
7. Considers their financial capacity for improvements

Format the report with clear sections, headers (using **bold**), and bullet points.
Return ONLY the report text, no JSON formatting.
```

### n8n Response Configuration:

In the "Respond to Webhook" node:
- **Response Mode:** "Text"
- **Response Body:** `{{$json.ai_response}}` (or whatever variable contains your AI output)
- **Response Code:** 200
- **Response Headers:** `Content-Type: text/plain`

## UI Features

### Floating Action Button
- **Position:** Bottom right of the screen
- **Icon:** ✨ (auto_awesome) with purple background
- **Label:** "AI Analysis"
- **States:**
  - Normal: Purple button with sparkle icon
  - Loading: Shows spinner with "Generating..." text
  - Disabled: Button disabled while loading

### Report Dialog
- **Title:** "AI Improvement Analysis" with sparkle icon
- **Content:** Scrollable text area displaying the AI-generated report
- **Actions:** Close button
- **Styling:** Clean, professional dialog with purple accent

## Error Handling

The app includes:
- Loading state indicator
- Error snackbar for failed requests
- Network timeout handling
- Graceful fallback messages

## Testing

To test without n8n:
1. Set up a simple HTTP server that returns plain text
2. Point the webhook URL to your test server
3. Return plain text (not JSON)

Example test response (plain text):
```
This is a test AI report.

Your company is doing great in most areas!

Areas for improvement:
1. Gender equality needs attention
2. Water usage could be optimized

Keep up the good work!
```
