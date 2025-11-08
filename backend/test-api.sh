#!/bin/bash

# ESG Backend API Test Script
# Make sure the server is running: pnpm dev

BASE_URL="http://localhost:420/api"

echo "🧪 Testing ESG Backend API"
echo "=========================="
echo ""

# Test 1: Health check
echo "1️⃣  Testing server health..."
curl -s "$BASE_URL/../" | jq
echo ""

# Test 2: Get all companies
echo "2️⃣  Getting all companies..."
curl -s "$BASE_URL/companies" | jq '. | length'
echo " companies found"
echo ""

# Test 3: Get summary stats
echo "3️⃣  Getting summary statistics..."
curl -s "$BASE_URL/stats/summary" | jq
echo ""

# Test 4: Get specific company by code
echo "4️⃣  Getting DemoCo company..."
DEMOCO=$(curl -s "$BASE_URL/companies/by-code/IT-DEMOCO-2024")
echo "$DEMOCO" | jq '{
  company: .company_profile.basic_information.trade_name,
  overall_score: .report.overall_score,
  completeness: .report.qa.completeness_pct,
  assured: .report.qa.has_external_assurance
}'
echo ""

# Test 5: Get just the report
echo "5️⃣  Getting first company ID..."
FIRST_ID=$(curl -s "$BASE_URL/companies" | jq -r '.[0]._id')
echo "First company ID: $FIRST_ID"
echo ""

echo "6️⃣  Getting report for first company..."
curl -s "$BASE_URL/companies/$FIRST_ID/report" | jq '{
  overall_score: .overall_score,
  topic_count: (.topic_scores | length),
  sdg_count: (.sdg_scores | length),
  top_3_topics: (.topic_scores | sort_by(-.score) | .[0:3] | map({topic: .topic_code, score: .score}))
}'
echo ""

# Test 7: Create a new company (optional - commented out)
# echo "7️⃣  Creating a new test company..."
# curl -s -X POST "$BASE_URL/companies" \
#   -H "Content-Type: application/json" \
#   -d @examples/company_data.json | jq '{
#     created: true,
#     company: .company_profile.basic_information.trade_name,
#     score: .report.overall_score
#   }'
# echo ""

echo "✅ Tests complete!"
echo ""
echo "💡 View all data in browser:"
echo "   http://localhost:420/api/companies"
echo ""
echo "📊 Individual company reports:"
echo "   http://localhost:420/api/companies/by-code/IT-DEMOCO-2024"
echo "   http://localhost:420/api/companies/by-code/IT-GREENTECH-2024"
echo "   http://localhost:420/api/companies/by-code/IT-TECHCORP-2024"
