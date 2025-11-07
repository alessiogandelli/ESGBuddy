# 🚀 Quick Start Guide

## Getting Started in 5 Minutes

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Choose Your Data Source

#### Option A: Use Mock Data (No Backend Required)
Perfect for quick testing or when backend isn't ready.

In `lib/main.dart`, uncomment the mock repository:
```dart
// Comment out real backend:
// final apiService = ApiService(baseUrl: AppConfig.baseUrl);
// final esgRepository = EsgRepository(apiService: apiService);

// Uncomment mock data:
final esgRepository = MockEsgRepository();
```

#### Option B: Use n8n Backend
The app is pre-configured for your n8n instance at:

Make sure your n8n workflows expose these endpoints:
- `GET /metrics` - Returns list of ESG metrics
- `GET /companies` - Returns list of companies

#### Option C: Use Real Backend
Update `lib/config/app_config.dart`:
```dart
static const String baseUrl = 'https://your-api.com';
```

### 3. Run the App

#### Web (Recommended for Hackathon Demo)
```bash
flutter run -d chrome
```

#### Mobile
```bash
flutter run
```

#### All platforms
```bash
flutter run -d <device-id>
```

## 📱 App Features

- **Home Screen**: Displays companies and ESG metrics
- **Pull to Refresh**: Reload data from backend
- **Error Handling**: Graceful error messages with retry
- **Loading States**: Visual feedback during data fetching

## 🎨 Customization

### Add New Screen
1. Create in `lib/presentation/screens/`
2. Import and use repository
3. Add to navigation

### Add New Data Model
1. Create in `lib/models/`
2. Add JSON serialization
3. Add repository methods

### Change Theme
In `lib/main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // Change color
  useMaterial3: true,
),
```

## 🔧 Troubleshooting

### "No data available"
- Check if backend is running
- Verify endpoint URLs
- Try mock data first to verify UI works

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### CORS errors (Web)
- Add CORS headers to your backend
- Or run with: `flutter run -d chrome --web-browser-flag "--disable-web-security"`

## 📚 Project Structure

```
lib/
├── config/           # App configuration (backend URLs)
├── models/           # Data models (EsgMetric, CompanyProfile)
├── data/            # Data layer (API, repositories)
├── presentation/    # UI (screens, widgets)
└── main.dart        # App entry point
```

## 🎯 Hackathon Tips

1. **Start with mock data** - Get UI working first
2. **Switch to real backend** - Integrate when ready
3. **Use pull-to-refresh** - Easy way to reload data
4. **Customize theme** - Quick visual changes
5. **Add screens incrementally** - One feature at a time

## 📝 Sample n8n Workflow Response

Your n8n workflows should return JSON in this format:

**GET /companies**
```json
[
  {
    "id": "1",
    "name": "Company Name",
    "industry": "Technology",
    "esg_score": 85.5,
    "description": "Company description"
  }
]
```

**GET /metrics**
```json
[
  {
    "id": "1",
    "name": "Carbon Emissions",
    "category": "Environmental",
    "value": 1250.5,
    "unit": "tons CO2",
    "timestamp": "2025-11-07T10:00:00Z"
  }
]
```

## 🚢 Ready to Deploy?

The architecture is production-ready! Just:
1. Replace n8n URL with production API
2. Add authentication if needed (in `ApiService`)
3. Add state management (Provider/Riverpod) for complex state
4. Build for your platform: `flutter build web|apk|ios`

---

**Need help?** Check `ARCHITECTURE.md` for detailed documentation.
