import { MongoClient, Db } from 'mongodb';
import dotenv from 'dotenv';

dotenv.config();

const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017';
const DB_NAME = process.env.DB_NAME || 'esgbuddy';

// Sample data
const sampleItems = [
  {
    name: 'Solar Panel Installation',
    category: 'Environmental',
    impact: 'High',
    carbonReduction: 500,
    description: 'Installation of solar panels to reduce carbon footprint',
    date: new Date('2024-01-15')
  },
  {
    name: 'Employee Training Program',
    category: 'Social',
    impact: 'Medium',
    hoursProvided: 120,
    description: 'Quarterly training program for employee development',
    date: new Date('2024-02-01')
  },
  {
    name: 'Board Diversity Initiative',
    category: 'Governance',
    impact: 'High',
    diversityScore: 85,
    description: 'Increased board diversity to 40% women and minorities',
    date: new Date('2024-03-10')
  },
  {
    name: 'Waste Reduction Campaign',
    category: 'Environmental',
    impact: 'Medium',
    wasteReduced: 250,
    description: 'Company-wide initiative to reduce waste by 30%',
    date: new Date('2024-04-05')
  },
  {
    name: 'Community Outreach',
    category: 'Social',
    impact: 'High',
    peopleReached: 1000,
    description: 'Local community support and volunteer programs',
    date: new Date('2024-05-20')
  }
];

async function populateDatabase() {
  let client: MongoClient;
  
  try {
    // Connect to MongoDB
    client = new MongoClient(MONGO_URI);
    await client.connect();
    console.log('✅ Connected to MongoDB');
    
    const db: Db = client.db(DB_NAME);
    const collection = db.collection('items');
    
    // Clear existing data (optional)
    await collection.deleteMany({});
    console.log('🗑️  Cleared existing items');
    
    // Insert sample data
    const result = await collection.insertMany(sampleItems);
    console.log(`✨ Inserted ${result.insertedCount} sample items`);
    
    // Display inserted items
    const items = await collection.find({}).toArray();
    console.log('\n📊 Sample data:');
    items.forEach((item, index) => {
      console.log(`${index + 1}. ${item.name} (${item.category}) - Impact: ${item.impact}`);
    });
    
    console.log('\n✅ Database population complete!');
    
  } catch (error) {
    console.error('❌ Error populating database:', error);
    process.exit(1);
  } finally {
    if (client!) {
      await client.close();
      console.log('👋 Connection closed');
    }
  }
}

populateDatabase();
