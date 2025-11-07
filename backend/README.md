# Backend API

A simple Node.js backend with MongoDB using TypeScript.

## Setup

1. Install dependencies:
```bash
npm install
```

2. Make sure MongoDB is running locally on `mongodb://localhost:27017`

3. Configure your environment variables in `.env` file (already created with defaults)

## Running the Server

Development mode (with auto-restart):
```bash
npm run dev
```

Production build and run:
```bash
npm run build
npm start
```

## API Endpoints

- `GET /` - Health check
- `GET /api/items` - Get all items
- `POST /api/items` - Create a new item
- `GET /api/items/:id` - Get item by ID
- `PUT /api/items/:id` - Update item by ID
- `DELETE /api/items/:id` - Delete item by ID

## Example Usage

Create an item:
```bash
curl -X POST http://localhost:3000/api/items \
  -H "Content-Type: application/json" \
  -d '{"name": "Test Item", "description": "A test item"}'
```

Get all items:
```bash
curl http://localhost:3000/api/items
```
