import express, { Request, Response } from 'express';
import { MongoClient, Db, Collection } from 'mongodb';
import dotenv from 'dotenv';
import cors from 'cors';

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
