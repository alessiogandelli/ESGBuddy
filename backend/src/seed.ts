import { MongoClient, Db } from 'mongodb';
import dotenv from 'dotenv';
import { CompanyESGData, CompanyDocument } from './types/esg.types';
import { computeScores } from './services/compute.service';
import fs from 'fs';
import path from 'path';

dotenv.config();

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017';
const DB_NAME = process.env.DB_NAME || 'mydb';

// Sample company variations
const sampleCompanies: CompanyESGData[] = [];

// Load the base company data
const baseCompanyPath = path.join(__dirname, '../examples/company_data.json');
const baseCompany: CompanyESGData = JSON.parse(fs.readFileSync(baseCompanyPath, 'utf-8'));

// Company 1: Original Demo Company
sampleCompanies.push(baseCompany);

// Company 2: GreenTech Solutions - Better environmental scores
const greenTechCompany: CompanyESGData = JSON.parse(JSON.stringify(baseCompany));
greenTechCompany.report_metadata.report_id = "ESG-2024-DEMO-002";
greenTechCompany.report_metadata.company_id = "IT-GREENTECH-2024";
greenTechCompany.company_profile.basic_information.legal_name = "GreenTech Solutions S.p.A.";
greenTechCompany.company_profile.basic_information.trade_name = "GreenTech";
greenTechCompany.company_profile.basic_information.website = "https://www.greentech.it";
greenTechCompany.company_profile.financial_metrics.annual_revenue = 75000000;
greenTechCompany.company_profile.workforce_profile.total_employees = 620;
greenTechCompany.topics.environmental.energy_climate.metrics.renewable_energy_pct = 95;
greenTechCompany.topics.environmental.energy_climate.metrics.scope1_tco2e = 450;
greenTechCompany.topics.environmental.energy_climate.metrics.scope2_market_tco2e = 200;
greenTechCompany.topics.environmental.energy_climate.metrics.emissions_intensity_tco2e_per_m_eur = 8.7;
greenTechCompany.topics.environmental.waste.metrics.recycling_rate_pct = 88.5;
greenTechCompany.topics.social.workforce.metrics.women_in_management = 35;
greenTechCompany.topics.social.diversity_equity!.metrics.gender_pay_gap_pct = 1.2;
sampleCompanies.push(greenTechCompany);

// Company 3: TechCorp Italia - Mid-range performance
const techCorpCompany: CompanyESGData = JSON.parse(JSON.stringify(baseCompany));
techCorpCompany.report_metadata.report_id = "ESG-2024-DEMO-003";
techCorpCompany.report_metadata.company_id = "IT-TECHCORP-2024";
techCorpCompany.company_profile.basic_information.legal_name = "TechCorp Italia S.r.l.";
techCorpCompany.company_profile.basic_information.trade_name = "TechCorp";
techCorpCompany.company_profile.basic_information.website = "https://www.techcorp.it";
techCorpCompany.company_profile.basic_information.headquarters.address = "Via Torino 45, 10123 Torino, Italy";
techCorpCompany.company_profile.basic_information.headquarters.region = "Piedmont";
techCorpCompany.company_profile.financial_metrics.annual_revenue = 35000000;
techCorpCompany.company_profile.workforce_profile.total_employees = 280;
techCorpCompany.topics.environmental.energy_climate.metrics.renewable_energy_pct = 45;
techCorpCompany.topics.environmental.energy_climate.metrics.scope1_tco2e = 1800;
techCorpCompany.topics.environmental.energy_climate.metrics.emissions_intensity_tco2e_per_m_eur = 51.4;
techCorpCompany.topics.environmental.waste.metrics.recycling_rate_pct = 58.0;
techCorpCompany.topics.social.health_safety.metrics.recordable_injuries = 8;
techCorpCompany.topics.social.health_safety.metrics.lost_time_injuries = 4;
techCorpCompany.topics.social.health_safety.metrics.trir = 1.82;
techCorpCompany.topics.social.health_safety.metrics.ltir = 0.91;
techCorpCompany.topics.social.training.metrics.avg_training_hours_per_employee = 18.5;
techCorpCompany.topics.governance.supply_chain.metrics.suppliers_audited_esg_pct = 35;
techCorpCompany.report_metadata.statement_of_use.external_assurance!.assured = false;
sampleCompanies.push(techCorpCompany);

async function seedDatabase() {
  const client = new MongoClient(MONGO_URI);
  
  try {
    await client.connect();
    console.log('✅ Connected to MongoDB');
    
    const db: Db = client.db(DB_NAME);
    const collection = db.collection<CompanyDocument>('companies');
    
    // Clear existing data
    const deleteResult = await collection.deleteMany({});
    console.log(`🗑️  Deleted ${deleteResult.deletedCount} existing companies`);
    
    // Insert sample companies with computed reports
    console.log('\n📊 Computing and inserting sample companies...\n');
    
    for (const companyData of sampleCompanies) {
      const computedReport = computeScores(companyData);
      
      const companyDocument: CompanyDocument = {
        ...companyData,
        report: computedReport,
        created_at: new Date(),
        updated_at: new Date()
      };
      
      const result = await collection.insertOne(companyDocument as any);
      
      console.log(`✅ ${companyData.company_profile.basic_information.trade_name}`);
      console.log(`   Company ID: ${companyData.report_metadata.company_id}`);
      console.log(`   Overall Score: ${computedReport.overall_score}/100`);
      console.log(`   Completeness: ${computedReport.qa.completeness_pct}%`);
      console.log(`   External Assurance: ${computedReport.qa.has_external_assurance ? 'Yes' : 'No'}`);
      console.log(`   MongoDB _id: ${result.insertedId}`);
      console.log('');
    }
    
    console.log(`\n🎉 Successfully seeded ${sampleCompanies.length} companies with ESG reports!`);
    console.log(`\n📍 Access them at: http://localhost:${process.env.PORT || 420}/api/companies`);
    
  } catch (error) {
    console.error('❌ Error seeding database:', error);
    process.exit(1);
  } finally {
    await client.close();
    console.log('\n👋 Database connection closed');
  }
}

// Run the seed function
seedDatabase();
