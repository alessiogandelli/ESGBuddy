import express, { Request, Response } from 'express';
import { MongoClient, Db, Collection, ObjectId } from 'mongodb';
import dotenv from 'dotenv';
import cors from 'cors';
import { CompanyESGData, CompanyDocument } from './types/esg.types';
import { computeScores } from './services/compute.service';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 420;
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017';
const DB_NAME = process.env.DB_NAME || 'mydb';

// Middleware
app.use(cors());
app.use(express.json());

let db: Db;
let client: MongoClient;

// Connect to MongoDB
async function connectToDatabase() {
  try {
    client = new MongoClient(MONGO_URI);
    await client.connect();
    db = client.db(DB_NAME);
    console.log('✅ Connected to MongoDB');
  } catch (error) {
    console.error('❌ MongoDB connection error:', error);
    process.exit(1);
  }
}

// Basic health check route
app.get('/', (req: Request, res: Response) => {
  res.json({ message: 'Backend server is running!' });
});

// Get all items from a collection
app.get('/api/items', async (req: Request, res: Response) => {
  try {
    const collection: Collection = db.collection('items');
    const items = await collection.find({}).toArray();
    res.json(items);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch items' });
  }
});

// Create a new item
app.post('/api/items', async (req: Request, res: Response) => {
  try {
    const collection: Collection = db.collection('items');
    const result = await collection.insertOne(req.body);
    res.status(201).json({ _id: result.insertedId, ...req.body });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create item' });
  }
});

// Get a single item by ID
app.get('/api/items/:id', async (req: Request, res: Response) => {
  try {
    const { ObjectId } = require('mongodb');
    const collection: Collection = db.collection('items');
    const item = await collection.findOne({ _id: new ObjectId(req.params.id) });
    
    if (!item) {
      return res.status(404).json({ error: 'Item not found' });
    }
    
    res.json(item);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch item' });
  }
});

// Update an item
app.put('/api/items/:id', async (req: Request, res: Response) => {
  try {
    const { ObjectId } = require('mongodb');
    const collection: Collection = db.collection('items');
    const result = await collection.updateOne(
      { _id: new ObjectId(req.params.id) },
      { $set: req.body }
    );
    
    if (result.matchedCount === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }
    
    res.json({ message: 'Item updated successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to update item' });
  }
});

// Delete an item
app.delete('/api/items/:id', async (req: Request, res: Response) => {
  try {
    const { ObjectId } = require('mongodb');
    const collection: Collection = db.collection('items');
    const result = await collection.deleteOne({ _id: new ObjectId(req.params.id) });
    
    if (result.deletedCount === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }
    
    res.json({ message: 'Item deleted successfully' });
  } catch (error) {
    res.status(500).json({ error: 'Failed to delete item' });
  }
});

// ============== ESG Company Reports Endpoints ==============

// Get all companies with their reports
app.get('/api/companies', async (req: Request, res: Response) => {
  try {
    const collection: Collection<CompanyDocument> = db.collection('companies');
    const companies = await collection.find({}).toArray();
    res.json(companies);
  } catch (error) {
    console.error('Error fetching companies:', error);
    res.status(500).json({ error: 'Failed to fetch companies' });
  }
});

// Get a single company by ID
app.get('/api/companies/:id', async (req: Request, res: Response) => {
  try {
    const collection: Collection<CompanyDocument> = db.collection('companies');
    const company = await collection.findOne({ _id: new ObjectId(req.params.id) });
    
    if (!company) {
      return res.status(404).json({ error: 'Company not found' });
    }
    
    res.json(company);
  } catch (error) {
    console.error('Error fetching company:', error);
    res.status(500).json({ error: 'Failed to fetch company' });
  }
});

// Get company by company_id (from metadata)
app.get('/api/companies/by-code/:companyId', async (req: Request, res: Response) => {
  try {
    const collection: Collection<CompanyDocument> = db.collection('companies');
    const company = await collection.findOne({ 
      'report_metadata.company_id': req.params.companyId 
    });
    
    if (!company) {
      return res.status(404).json({ error: 'Company not found' });
    }
    
    res.json(company);
  } catch (error) {
    console.error('Error fetching company:', error);
    res.status(500).json({ error: 'Failed to fetch company' });
  }
});

// Create a new company and compute its ESG report
app.post('/api/companies', async (req: Request, res: Response) => {
  try {
    const companyData: CompanyESGData = req.body;
    
    // Validate required fields
    if (!companyData.report_metadata || !companyData.company_profile || !companyData.topics) {
      return res.status(400).json({ 
        error: 'Missing required fields: report_metadata, company_profile, and topics are required' 
      });
    }

    // Compute the ESG scores and report
    console.log('Computing ESG scores for company:', companyData.report_metadata.company_id);
    const computedReport = computeScores(companyData);

    // Create company document with computed report
    const companyDocument: CompanyDocument = {
      ...companyData,
      report: computedReport,
      created_at: new Date(),
      updated_at: new Date()
    };

    const collection: Collection<CompanyDocument> = db.collection('companies');
    const result = await collection.insertOne(companyDocument as any);

    console.log('✅ Company created with report. Overall score:', computedReport.overall_score);

    res.status(201).json({
      _id: result.insertedId,
      ...companyDocument
    });
  } catch (error: any) {
    console.error('Error creating company:', error);
    
    // Handle duplicate key error
    if (error.code === 11000) {
      return res.status(409).json({ 
        error: 'Duplicate company entry',
        message: 'A company with this ID already exists',
        duplicateKey: error.keyValue
      });
    }
    
    res.status(500).json({ error: 'Failed to create company and compute report' });
  }
});

// Update company data and recompute report
app.put('/api/companies/:id', async (req: Request, res: Response) => {
  try {
    const companyData: CompanyESGData = req.body;
    
    // Compute new report
    const computedReport = computeScores(companyData);

    const collection: Collection<CompanyDocument> = db.collection('companies');
    const result = await collection.updateOne(
      { _id: new ObjectId(req.params.id) },
      { 
        $set: {
          ...companyData,
          report: computedReport,
          updated_at: new Date()
        }
      }
    );
    
    if (result.matchedCount === 0) {
      return res.status(404).json({ error: 'Company not found' });
    }

    console.log('✅ Company updated with new report. Overall score:', computedReport.overall_score);
    
    res.json({ 
      message: 'Company updated and report recomputed successfully',
      overall_score: computedReport.overall_score
    });
  } catch (error) {
    console.error('Error updating company:', error);
    res.status(500).json({ error: 'Failed to update company' });
  }
});

// Get only the computed report for a company
app.get('/api/companies/:id/report', async (req: Request, res: Response) => {
  try {
    const collection: Collection<CompanyDocument> = db.collection('companies');
    const company = await collection.findOne({ _id: new ObjectId(req.params.id) });
    
    if (!company) {
      return res.status(404).json({ error: 'Company not found' });
    }

    if (!company.report) {
      return res.status(404).json({ error: 'Report not computed for this company' });
    }
    
    res.json(company.report);
  } catch (error) {
    console.error('Error fetching report:', error);
    res.status(500).json({ error: 'Failed to fetch report' });
  }
});

// Delete a company
app.delete('/api/companies/:id', async (req: Request, res: Response) => {
  try {
    const collection: Collection<CompanyDocument> = db.collection('companies');
    const result = await collection.deleteOne({ _id: new ObjectId(req.params.id) });
    
    if (result.deletedCount === 0) {
      return res.status(404).json({ error: 'Company not found' });
    }
    
    res.json({ message: 'Company deleted successfully' });
  } catch (error) {
    console.error('Error deleting company:', error);
    res.status(500).json({ error: 'Failed to delete company' });
  }
});

// Get summary stats across all companies
app.get('/api/stats/summary', async (req: Request, res: Response) => {
  try {
    const collection: Collection<CompanyDocument> = db.collection('companies');
    const companies = await collection.find({}).toArray();
    
    const stats = {
      total_companies: companies.length,
      average_overall_score: companies.reduce((sum, c) => sum + (c.report?.overall_score || 0), 0) / companies.length || 0,
      companies_with_assurance: companies.filter(c => c.report?.qa.has_external_assurance).length,
      average_completeness: companies.reduce((sum, c) => sum + (c.report?.qa.completeness_pct || 0), 0) / companies.length || 0
    };
    
    res.json(stats);
  } catch (error) {
    console.error('Error fetching stats:', error);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

// Start server
async function startServer() {
  await connectToDatabase();
  
  app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
  });
}

// Handle graceful shutdown
process.on('SIGINT', async () => {
  console.log('\n👋 Closing MongoDB connection...');
  await client.close();
  process.exit(0);
});

startServer();
