# ESG Buddy - Architecture Documentation

## 🏗️ Project Structure

This Flutter app follows a clean architecture pattern with clear separation between data and presentation layers:

```
lib/
├── config/
│   └── app_config.dart          # Backend configuration
├── models/                       # Domain models
│   ├── esg_metric.dart
│   └── company_profile.dart
├── data/                         # Data layer
│   ├── api_service.dart         # Generic HTTP client
│   └── esg_repository.dart      # Data access abstraction
├── presentation/                 # UI layer
│   └── screens/
│       └── home_screen.dart     # Main screen
└── main.dart                     # App entry point
```

## 🔄 Architecture Layers

### 1. **Models Layer** (`lib/models/`)
- Pure Dart classes representing domain entities
- No dependencies on Flutter or external packages
- Include JSON serialization for API communication
- Examples: `EsgMetric`, `CompanyProfile`

### 2. **Data Layer** (`lib/data/`)
- **ApiService**: Generic HTTP client for API calls
  - Configured for n8n with ngrok headers
  - Supports GET, POST, PUT, DELETE
  - Easy to swap implementations
  
- **EsgRepository**: Abstracts data access
  - Business logic for data fetching
  - Transforms API responses into domain models
  - Makes it easy to change backends without affecting UI

### 3. **Presentation Layer** (`lib/presentation/`)
- Flutter widgets and screens
- Consumes data from repositories
- No direct API calls - uses repositories instead
- Handles UI state and user interactions

### 4. **Configuration** (`lib/config/`)
- Centralized app configuration
- Backend URL management
- Easy switching between n8n and production backends

## 🔌 Backend Integration

### Current Setup: n8n
The app is configured to work with your n8n backend at:
```dart
static const String n8nBaseUrl = 'ngrok.app';
```

### Expected API Endpoints:
- `GET /metrics` - Fetch ESG metrics
- `GET /metrics/:id` - Fetch single metric
- `POST /metrics` - Create new metric
- `GET /companies` - Fetch all companies
- `GET /companies/:id` - Fetch single company

### Switching to a Real Backend:
Simply update `lib/config/app_config.dart`:

```dart
class AppConfig {
  // Option 1: Update the base URL
  static const String baseUrl = 'https://api.yourdomain.com';
  
  // Option 2: Or create multiple configs
  static const String n8nBaseUrl = 'https://ngrok.app';
  static const String productionBaseUrl = 'https://api.yourdomain.com';
  static const String baseUrl = productionBaseUrl; // Switch here
}
```

No other code changes needed! The repository pattern abstracts the data source.

## 🚀 Running the App

1. **Get dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **For web:**
   ```bash
   flutter run -d chrome
   ```

## 📊 Sample Data Format

### ESG Metric:
```json
{
  "id": "metric_1",
  "name": "Carbon Emissions",
  "category": "Environmental",
  "value": 1250.5,
  "unit": "tons CO2",
  "timestamp": "2025-11-07T10:00:00Z"
}
```

### Company Profile:
```json
{
  "id": "company_1",
  "name": "Green Tech Inc",
  "industry": "Technology",
  "esg_score": 85.5,
  "description": "Leading sustainable tech company"
}
```

## 🎯 Key Benefits of This Architecture

1. **Separation of Concerns**: UI code is completely separate from data fetching
2. **Easy Testing**: Each layer can be tested independently
3. **Backend Flexibility**: Switch from n8n to any backend by changing one file
4. **Scalability**: Add new features without touching existing code
5. **Hackathon Ready**: Clean structure makes it easy to iterate quickly

## 🔧 Adding New Features

### Adding a new data model:
1. Create model in `lib/models/`
2. Add repository methods in `lib/data/esg_repository.dart`
3. Use in presentation layer

### Adding a new screen:
1. Create screen in `lib/presentation/screens/`
2. Inject repository via constructor
3. Add routing in `main.dart`

### Changing API structure:
- Only update the repository layer
- UI code remains unchanged

## 📝 Notes for Hackathon

- **Quick iterations**: Change UI without worrying about breaking data layer
- **Team collaboration**: Frontend and backend teams can work independently
- **Demo ready**: Easy to mock data if backend isn't ready
- **Production ready**: Architecture scales to production use

## 🛠️ Troubleshooting

### CORS Issues with n8n:
The app includes `ngrok-skip-browser-warning` header for n8n via ngrok.

### No data showing:
1. Check n8n endpoint is accessible
2. Verify endpoint paths match your n8n workflows
3. Check browser console for error messages

### Backend not responding:
- Ensure n8n is running
- Verify ngrok URL is current
- Check network connectivity
